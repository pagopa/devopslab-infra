resource "azurerm_resource_group" "cosmosdb_dapr" {
  name     = "${local.project}-dapr-cosmos-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_cosmosdb_account" "mongodb" {
  name                = "${local.project}-dapr-cosmos"
  location            = azurerm_resource_group.cosmosdb_dapr.location
  resource_group_name = azurerm_resource_group.cosmosdb_dapr.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  capabilities {
    name = "EnableServerless"
  }

    consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "db_dapr" {
  name                = "mydbdapr"
  resource_group_name = azurerm_resource_group.cosmosdb_dapr.name
  account_name        = azurerm_cosmosdb_account.mongodb.name
}

resource "azurerm_cosmosdb_mongo_collection" "collection_dapr" {
  name                = "mycollectiondapr"
  resource_group_name = azurerm_resource_group.cosmosdb_dapr.name
  account_name        = azurerm_cosmosdb_account.mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.db_dapr.name

  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"

  index {
    keys   = ["_id"]
    unique = true
  }
}
