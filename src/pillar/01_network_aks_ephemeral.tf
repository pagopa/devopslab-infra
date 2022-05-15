resource "azurerm_resource_group" "rg_vnet_ephemeral" {
  name     = local.vnet_ephemeral_resource_group_name
  location = var.location

  tags = var.tags
}

# vnet
module "vnet_ephemeral" {
  source              = "git::https://github.com/pagopa/azurerm.git//virtual_network?ref=v2.8.1"
  name                = local.vnet_ephemeral_name
  location            = azurerm_resource_group.rg_vnet_ephemeral.location
  resource_group_name = azurerm_resource_group.rg_vnet_ephemeral.name
  address_space       = var.cidr_ephemeral_vnet

  tags = var.tags
}

#
#  AKS public IP
#

resource "azurerm_public_ip" "aks_ephemeral_outbound_ip" {
  count = var.aks_ephemeral_num_outbound_ips

  name                = "${local.aks_ephemeral_public_ip_name}-${count.index + 1}"
  location            = azurerm_resource_group.rg_vnet_ephemeral.location
  resource_group_name = azurerm_resource_group.rg_vnet_ephemeral.name
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}
