locals {
  aks_network_prefix = "${var.prefix}-${var.env_short}-${var.location_short}"
  iterate_network    = { for n in var.aks_networks : index(var.aks_networks.*.domain_name, n.domain_name) => n }
}

resource "azurerm_resource_group" "rg_vnet_aks" {

  for_each = { for n in var.aks_networks : n.domain_name => n }
  name     = "${local.aks_network_prefix}-${each.key}-aks-vnet-rg"
  location = var.location

  tags = var.tags
}

# vnet
module "vnet_aks" {

  for_each = { for n in var.aks_networks : n.domain_name => n }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v6.3.1"

  name                = "${local.aks_network_prefix}-${each.key}-aks-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet_aks[each.key].name
  address_space       = each.value["vnet_cidr"]

  tags = var.tags
}

#
#  AKS public IP
#

resource "azurerm_public_ip" "outbound_ip_aks" {
  for_each = { for n in var.aks_networks : n.domain_name => index(var.aks_networks.*.domain_name, n.domain_name) }


  name                = "${local.program}-${each.key}-aksoutbound-pip-${each.value + 1}"
  location            = azurerm_resource_group.rg_vnet_aks[each.key].location
  resource_group_name = azurerm_resource_group.rg_vnet_aks[each.key].name
  sku                 = "Standard"
  allocation_method   = "Static"

  zones = [1, 2, 3]

  tags = var.tags
}

# #
# # -------------------------------------------------------------------------
# #

module "vnet_peering_core_2_aks" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.3.1"

  for_each = { for n in var.aks_networks : n.domain_name => n }


  location = var.location

  source_resource_group_name       = data.azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = data.azurerm_virtual_network.vnet.name
  source_remote_virtual_network_id = data.azurerm_virtual_network.vnet.id
  source_allow_gateway_transit     = true # needed by vpn gateway for enabling routing from vnet to vnet_integration

  target_resource_group_name       = azurerm_resource_group.rg_vnet_aks[each.key].name
  target_virtual_network_name      = module.vnet_aks[each.key].name
  target_remote_virtual_network_id = module.vnet_aks[each.key].id
  target_use_remote_gateways       = true # needed by vpn gateway for enabling routing from vnet to vnet_integration
}

#
# Private DNS links
#
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_aks" {
  for_each = { for n in var.aks_networks : n.domain_name => n }

  name                  = module.vnet_aks[each.key].name
  resource_group_name   = data.azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = data.azurerm_private_dns_zone.internal.name
  virtual_network_id    = module.vnet_aks[each.key].id

  tags = var.tags
}


resource "azurerm_private_dns_zone_virtual_network_link" "storage_account_vnet" {
  for_each              = { for n in var.aks_networks : n.domain_name => n }
  name                  = module.vnet_aks[each.key].name
  resource_group_name   = data.azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = data.azurerm_private_dns_zone.storage.name
  virtual_network_id    = module.vnet_aks[each.key].id
}
