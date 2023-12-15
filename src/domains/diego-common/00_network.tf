data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_resource_group" "rg_vnet_core" {
  name = local.vnet_core_resource_group_name
}

data "azurerm_subnet" "private_endpoint" {
  name                 = "${local.product}-private-endpoints-snet"
  virtual_network_name = local.vnet_core_name
  resource_group_name  = local.vnet_core_resource_group_name
}

data "azurerm_dns_zone" "public" {
  name                = local.dns_zone_public_name
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "storage_account_private_dns_zone" {
  name = "privatelink.blob.core.windows.net"
  resource_group_name = local.vnet_core_resource_group_name
}
