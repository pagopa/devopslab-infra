#
# 🌐 Network
#
data "azurerm_resource_group" "rg_vnet_ita" {
  name = local.vnet_resource_group_name
}

data "azurerm_virtual_network" "vnet_ita_core" {
  name                = local.vnet_name
  resource_group_name = data.azurerm_resource_group.rg_vnet_ita.name
}
