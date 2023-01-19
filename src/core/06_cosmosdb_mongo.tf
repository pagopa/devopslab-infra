resource "azurerm_resource_group" "cosmos_mongo_rg" {
  count = local.cosmosdb_enable

  name     = "${local.program}-${var.domain}-cosmos-mongo-rg"
  location = var.location

  tags = var.tags
}

locals {

  cosmosdb_mongodb_enable_serverless = "EnableServerless"
}

module "cosmos_mongo" {
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_account?ref=v3.15.0"
  name     = "${local.project}-cosmos-mongo"
  location = var.location
  domain   = var.domain

  resource_group_name  = azurerm_resource_group.cosmos_mongo_rg[0].name
  offer_type           = "Standard"
  kind                 = "MongoDB"
  capabilities         = ["EnableMongo"]
  mongo_server_version = "4.0"

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
  private_endpoint_name    = "${local.project}-cosmos-mongo-sql-endpoint"
  private_endpoint_enabled = true
  subnet_id                = module.private_endpoints_snet.id
  private_dns_zone_ids     = [data.azurerm_private_dns_zone.internal.id]

  tags = var.tags

}

resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
  name                = "mongoDB"
  resource_group_name = azurerm_resource_group.cosmos_mongo_rg[0].name
  account_name        = module.cosmos_mongo.name

  throughput = null

  dynamic "autoscale_settings" {
    for_each = []
    content {
      max_throughput = 100
    }
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
  }
}

module "mongdb_collection_name" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_mongodb_collection?ref=v3.15.0"

  name                = "collectionName"
  resource_group_name = azurerm_resource_group.cosmos_mongo_rg[0].name

  cosmosdb_mongo_account_name  = module.cosmos_mongo.name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.mongo_db.name

  indexes = [{
    keys   = ["_id"]
    unique = true
    },
    {
      keys   = ["key1", "key2", "key3"]
      unique = true
    },
    {
      keys   = ["key4"]
      unique = false
    }
  ]

  lock_enable = true
}
