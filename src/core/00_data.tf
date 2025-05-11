data "azurerm_virtual_network" "vnet_ita_core" {
  name                = local.vnet_ita_name
  resource_group_name = local.vnet_ita_resource_group_name
}
