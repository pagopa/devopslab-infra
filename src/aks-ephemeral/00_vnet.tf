data "azurerm_resource_group" "rg_vnet_ephemeral" {
  name = local.vnet_ephemeral_resource_group_name
}

data "azurerm_virtual_network" "ephemeral_vnet" {
  name                = local.vnet_ephemeral_name
  resource_group_name = data.azurerm_resource_group.rg_vnet_ephemeral.name
}

data "azurerm_public_ip" "aks_pip" {
  name                = local.aks_ephemeral_public_ip_index_name
  resource_group_name = local.vnet_ephemeral_resource_group_name
}
