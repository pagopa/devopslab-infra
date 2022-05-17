#
# Core
#

data "azurerm_resource_group" "vnet_core_rg" {
  name = local.vnet_core_resource_group_name
}

data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = data.azurerm_resource_group.vnet_core_rg.name
}
