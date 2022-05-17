resource "azurerm_resource_group" "rg_vnet_aks" {
  name     = local.vnet_aks_resource_group_name
  location = var.location

  tags = var.tags
}

# vnet
module "vnet_aks" {
  source              = "git::https://github.com/pagopa/azurerm.git//virtual_network?ref=v2.8.1"
  name                = local.vnet_aks_name
  location            = azurerm_resource_group.rg_vnet_aks.location
  resource_group_name = azurerm_resource_group.rg_vnet_aks.name
  address_space       = var.cidr_ephemeral_vnet

  tags = var.tags
}

# k8s cluster subnet
module "snet_aks" {
  source = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.8.1"
  name   = "${local.project}-aks-snet"

  resource_group_name  = azurerm_resource_group.rg_vnet_aks.name
  virtual_network_name = module.vnet_aks.name

  address_prefixes                               = var.cidr_ephemeral_subnet_aks
  enforce_private_link_endpoint_network_policies = var.aks_private_cluster_enabled

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]
}

#
#  AKS public IP
#

resource "azurerm_public_ip" "outbound_ip_aks" {
  count = var.aks_num_outbound_ips

  name                = "${local.aks_public_ip_name}-${count.index + 1}"
  location            = azurerm_resource_group.rg_vnet_aks.location
  resource_group_name = azurerm_resource_group.rg_vnet_aks.name
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}

#
# -------------------------------------------------------------------------
#

module "vnet_peering_core_2_aks" {
  source = "git::https://github.com/pagopa/azurerm.git//virtual_network_peering?ref=v2.12.2"

  location = var.location

  source_resource_group_name       = data.azurerm_resource_group.vnet_core_rg.name
  source_virtual_network_name      = data.azurerm_virtual_network.vnet_core.name
  source_remote_virtual_network_id = data.azurerm_virtual_network.vnet_core.id
  source_allow_gateway_transit     = false # needed by vpn gateway for enabling routing from vnet to vnet_integration

  target_resource_group_name       = azurerm_resource_group.rg_vnet_aks.name
  target_virtual_network_name      = module.vnet_aks.name
  target_remote_virtual_network_id = module.vnet_aks.id
  target_use_remote_gateways       = false # needed by vpn gateway for enabling routing from vnet to vnet_integration
}
