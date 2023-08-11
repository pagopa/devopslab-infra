data "azurerm_resource_group" "rg_vnet" {
  name = local.vnet_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
}

data "azurerm_private_dns_zone" "internal" {
  name                = local.dns_zone_private_name
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
}

data "azurerm_private_dns_zone" "privatelink_postgres_database_azure_com" {
  name                = local.dns_zone_private_name_postgres
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
}

data "azurerm_subnet" "private_endpoints_snet" {
  name                 = "${local.program}-private-endpoints-snet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg_vnet.name
}
