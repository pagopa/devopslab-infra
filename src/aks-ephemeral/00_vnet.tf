#
# Core
#

data "azurerm_resource_group" "core_vnet_rg" {
  name = local.vnet_core_resource_group_name
}

data "azurerm_virtual_network" "core_vnet" {
  name                = local.vnet_core_name
  resource_group_name = data.azurerm_resource_group.core_vnet_rg.name
}


#
# Ephemeral
#

data "azurerm_resource_group" "ephemeral_vnet_rg" {
  name = local.vnet_ephemeral_resource_group_name
}

data "azurerm_virtual_network" "ephemeral_vnet" {
  name                = local.vnet_ephemeral_name
  resource_group_name = data.azurerm_resource_group.ephemeral_vnet_rg.name
}

data "azurerm_public_ip" "aks_ephemeral_pip" {
  name                = local.aks_ephemeral_public_ip_index_name
  resource_group_name = local.vnet_ephemeral_resource_group_name
}

#
# -------------------------------------------------------------------------
#

module "vnet_peering_core_2_aks_ephemeral" {
  source = "git::https://github.com/pagopa/azurerm.git//virtual_network_peering?ref=v2.12.2"

  location = var.location

  source_resource_group_name       = data.azurerm_resource_group.core_vnet_rg.name
  source_virtual_network_name      = data.azurerm_virtual_network.core_vnet.name
  source_remote_virtual_network_id = data.azurerm_virtual_network.core_vnet.id
  source_allow_gateway_transit     = false # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = data.azurerm_resource_group.ephemeral_vnet_rg.name
  target_virtual_network_name      = data.azurerm_virtual_network.ephemeral_vnet.name
  target_remote_virtual_network_id = data.azurerm_virtual_network.ephemeral_vnet.id
  target_use_remote_gateways       = false # needed by vpn gateway for enabling routing from vnet to vnet_integration
}
