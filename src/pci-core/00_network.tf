data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_virtual_network" "vnet_aks_dev01" {
  name                = local.vnet_aks_dev01_name
  resource_group_name = local.vnet_aks_dev01_resource_group_name
}
