resource "azurerm_resource_group" "idh_rg" {
  location = var.location
  name     = "${local.project}-idh-rg"
}


module "cosmosdb_account" {
  source = "./.terraform/modules/__v4__/IDH/cosmosdb_account"

  domain                     = var.domain
  name                       = "${local.project}-idh-cosmos-account"
  resource_group_name        = azurerm_resource_group.idh_rg.name
  location                   = var.location
  main_geo_location_location = var.location
  product_name               = "dvopla"
  env                        = "dev"
  idh_resource               = "cosmos_mongo6"
  tags = {}
}


module "event_hub" {
  source = "./.terraform/modules/__v4__/IDH/event_hub"

  name                = "${local.project}-idh-evh"
  product_name               = "dvopla"
  env                 = "dev"
  idh_resource_tier   = "standard"
  location            = var.location
  resource_group_name = azurerm_resource_group.idh_rg.name
  tags                = {}
}


module "key_vault" {
  source = "./.terraform/modules/__v4__/IDH/key_vault"

  name                = "${local.product_ita}-idh-kv"
  idh_resource        = "standard"
  product_name               = "dvopla"
  env                 = "dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.idh_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = {}
}


module "redis" {
  source = "./.terraform/modules/__v4__/IDH/redis"

  name                = "${local.project}-idh-redis"
  product_name               = "dvopla"
  env                 = "dev"
  idh_resource        = "basic"
  location            = var.location
  resource_group_name = azurerm_resource_group.idh_rg.name
  tags                = {}
}


# module "storage_account" {
#   source = "./.terraform/modules/__v4__/IDH/storage_account"
#
#   name                = replace("${local.project}-idh-sa", "-", "")
#
#   product_name               = "dvopla"
#   env                 = "dev"
#   idh_resource        = "standard"
#   domain              = "example"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.idh_rg.name
#   tags                = {}
# }

module "subnet" {
  source = "./.terraform/modules/__v4__/IDH/subnet"

  name                 = "${local.project}-idh-snet"
  resource_group_name = data.azurerm_virtual_network.vnet_ita.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_ita.name
  service_endpoints    = ["Microsoft.Storage"]
  idh_resource         = "postgres_flexible"
  product_name               = "dvopla"
  env                  = "dev"
}

# resource "random_password" "postgres_password" {
#   length           = 20
#   special          = true
#   min_lower        = 3
#   min_upper        = 3
#   min_numeric      = 3
#   min_special      = 3
# }
#
# module "postgres_flexible_server" {
#   source = "./.terraform/modules/__v4__/IDH/postgres_flexible_server"
#
#   name                   = "${local.project}-idh-flexible"
#   idh_resource           = "pgflex2"
#   product_name               = "dvopla"
#   env                    = "dev"
#   location               = var.location
#   resource_group_name = azurerm_resource_group.idh_rg.name
#   delegated_subnet_id    = module.subnet.subnet_id
#   administrator_login    = "adminuser"
#   administrator_password = random_password.postgres_password.result
#   tags = {}
# }


