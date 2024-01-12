data "azurerm_virtual_network" "vnet" {
  name                = "${local.project}-vnet"
  resource_group_name = local.vnet_resource_group_name
}
