#
# 🇮🇹 Vnet AKS
#
data "azurerm_resource_group" "vnet_italy_rg" {
  name = var.rg_vnet_italy_name
}

data "azurerm_virtual_network" "vnet_italy" {
  name                = var.vnet_italy_name
  resource_group_name = data.azurerm_resource_group.vnet_italy_rg.name
}

#
# 🇪🇺 CORE
#
data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_resource_group" "rg_vnet_core" {
  name = local.vnet_core_resource_group_name
}
