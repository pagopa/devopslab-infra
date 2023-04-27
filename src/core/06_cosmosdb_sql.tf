resource "azurerm_resource_group" "cosmos_rg" {
  count = var.is_cosmosdb_core_enabled ? 1 : 0

  name     = "${local.program}-${var.domain}-cosmos-rg"
  location = var.location

  tags = var.tags
}

module "cosmos_core" {
  count    = var.is_cosmosdb_core_enabled ? 1 : 0
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_account?ref=v6.3.1"
  name     = "${local.project}-cosmos-core"
  location = var.location
  domain   = var.domain

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
  private_endpoint_name    = "${local.project}-cosmos-core-sql-endpoint"
  private_endpoint_enabled = true
  subnet_id                = module.private_endpoints_snet.id
  private_dns_zone_ids     = [data.azurerm_private_dns_zone.internal.id]

  tags = var.tags

}

## Database
module "core_cosmos_db" {
  count = var.is_cosmosdb_core_enabled ? 1 : 0

  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_sql_database?ref=v6.3.1"
  name                = "db"
  resource_group_name = azurerm_resource_group.cosmos_rg[0].name
  account_name        = module.cosmos_core[0].name
}

### Containers
locals {
  core_cosmosdb_containers = var.is_cosmosdb_core_enabled ? [

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

  ] : []
}


module "core_cosmosdb_containers" {
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_sql_container?ref=v6.3.1"
  for_each = { for c in local.core_cosmosdb_containers : c.name => c }

  name                = each.value.name
  resource_group_name = azurerm_resource_group.cosmos_rg[0].name
  account_name        = module.cosmos_core[0].name
  database_name       = module.core_cosmos_db[0].name
  partition_key_path  = each.value.partition_key_path
  throughput          = lookup(each.value, "throughput", null)

  autoscale_settings = lookup(each.value, "autoscale_settings", null)

}
