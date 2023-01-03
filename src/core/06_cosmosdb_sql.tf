resource "azurerm_resource_group" "cosmos_rg" {
  count = local.cosmosdb_enable

  name     = "${local.program}-${var.domain}-cosmos-rg"
  location = var.location

  tags = var.tags
}

module "cosmos_core" {
  source   = "git::https://github.com/pagopa/azurerm.git//cosmosdb_account?ref=v3.12.0"
  name     = format("%s-cosmos-core", local.project)
  location = var.location
  domain = var.domain

  resource_group_name = azurerm_resource_group.cosmos_rg[0].name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  main_geo_location_zone_redundant = false

  enable_free_tier          = false
  enable_automatic_failover = true

  consistency_policy = {
    consistency_level       = "Strong"
    max_interval_in_seconds = null
    max_staleness_prefix    = null
  }

  main_geo_location_location = "northeurope"

  additional_geo_locations = [
    {
      location          = "westeurope"
      failover_priority = 1
      zone_redundant    = false
    }
  ]

  backup_continuous_enabled = true

  is_virtual_network_filter_enabled = true

  ip_range = ""

  allowed_virtual_network_subnet_ids = [
    module.private_endpoints_snet.id
  ]

  # private endpoint
  private_endpoint_name    = format("%s-cosmos-core-sql-endpoint", local.project)
  private_endpoint_enabled = true
  subnet_id                = module.private_endpoints_snet.id
  private_dns_zone_ids     = [data.azurerm_private_dns_zone.internal.id]

  tags = var.tags

}

## Database
module "core_cosmos_db" {
  source              = "git::https://github.com/pagopa/azurerm.git//cosmosdb_sql_database?ref=v2.1.15"
  name                = "db"
  resource_group_name = azurerm_resource_group.cosmos_rg[0].name
  account_name        = module.cosmos_core.name
}

### Containers
locals {
  core_cosmosdb_containers = [

    {
      name               = "user-cores"
      partition_key_path = "/fiscalCode"
      autoscale_settings = {
        max_throughput = 6000
      },
    },
    {
      name               = "user-eyca-cards"
      partition_key_path = "/fiscalCode"
      autoscale_settings = {
        max_throughput = 6000
      },
    },

  ]
}


module "core_cosmosdb_containers" {
  source   = "git::https://github.com/pagopa/azurerm.git//cosmosdb_sql_container?ref=v2.1.8"
  for_each = { for c in local.core_cosmosdb_containers : c.name => c }

  name                = each.value.name
  resource_group_name = azurerm_resource_group.cosmos_rg[0].name
  account_name        = module.cosmos_core.name
  database_name       = module.core_cosmos_db.name
  partition_key_path  = each.value.partition_key_path
  throughput          = lookup(each.value, "throughput", null)

  autoscale_settings = lookup(each.value, "autoscale_settings", null)

}
