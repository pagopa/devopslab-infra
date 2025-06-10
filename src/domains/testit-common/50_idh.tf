resource "azurerm_resource_group" "idh_rg" {
  location = var.location
  name     = "${local.project}-idh-rg"
}


module "cosmosdb_account" {
  count  = local.idh_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/cosmosdb_account"

  domain                     = var.domain
  name                       = "${local.project}-idh-cosmos-account"
  resource_group_name        = azurerm_resource_group.idh_rg.name
  location                   = var.location
  main_geo_location_location = var.location
  product_name               = "dvopla"
  env                        = "dev"
  idh_resource_tier          = "cosmos_mongo6"
  tags                       = {}
}


module "event_hub" {
  count  = local.idh_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/event_hub"

  name                = "${local.project}-idh-evh"
  product_name        = "dvopla"
  env                 = "dev"
  idh_resource_tier   = "standard"
  location            = var.location
  resource_group_name = azurerm_resource_group.idh_rg.name
  tags                = {}
}


module "key_vault" {
  count  = local.idh_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/key_vault"

  name                = "${local.product_ita}-idh-kv"
  idh_resource_tier   = "standard"
  product_name        = "dvopla"
  env                 = "dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.idh_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = {}
}


module "redis" {
  count  = local.idh_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/redis"

  name                = "${local.project}-idh-redis"
  product_name        = "dvopla"
  env                 = "dev"
  idh_resource_tier   = "basic"
  location            = var.location
  resource_group_name = azurerm_resource_group.idh_rg.name
  tags                = {}
}


module "storage_account" {
  count  = local.idh_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/storage_account"

  name = replace("${local.project}-idh-sa", "-", "")

  product_name        = "dvopla"
  env                 = "dev"
  idh_resource_tier   = "basic"
  domain              = var.domain
  location            = var.location
  resource_group_name = azurerm_resource_group.idh_rg.name
  tags                = {}
}

module "subnet" {
  count  = local.idh_enabled ? 1 : 0
  source = "./.terraform/modules/__v4__/IDH/subnet"

  name                 = "${local.project}-idh-snet"
  resource_group_name  = data.azurerm_virtual_network.vnet_ita.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_ita.name
  service_endpoints    = ["Microsoft.Storage"]
  idh_resource_tier    = "postgres_flexible"
  product_name         = "dvopla"
  env                  = "dev"
}

resource "random_password" "postgres_password" {
  count       = local.idh_enabled ? 1 : 0
  length      = 20
  special     = true
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
  min_special = 3
}

module "postgres_flexible_server" {
  count = local.idh_enabled ? 1 : 0

  source = "./.terraform/modules/__v4__/IDH/postgres_flexible_server"

  name                       = "${local.project}-idh-flexible"
  idh_resource_tier          = "pgflex2"
  product_name               = "dvopla"
  env                        = "dev"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.idh_rg.name
  delegated_subnet_id        = module.subnet[0].subnet_id
  administrator_login        = "adminuser"
  administrator_password     = random_password.postgres_password[0].result
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id
  tags                       = {}
}
