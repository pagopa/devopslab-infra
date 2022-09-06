data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

# vnet integration
data "azurerm_virtual_network" "vnet_integration" {
  name                = format("%s-%s-integration-vnet", var.prefix, var.env_short)
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = format("%s-%s-vnet", var.prefix, var.env_short)
  resource_group_name = local.vnet_core_resource_group_name
}
