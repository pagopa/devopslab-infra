resource "azurerm_resource_group" "rg_vnet" {
  name     = local.vnet_resource_group_name
  location = var.location

  tags = var.tags
}

# vnet
module "vnet" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v3.6.7"
  name                = local.vnet_name
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_vnet

  tags = var.tags
}

## Application gateway public ip ##
resource "azurerm_public_ip" "appgateway_public_ip" {
  name                = local.appgateway_public_ip_name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  zones = [1, 2, 3]

  tags = var.tags
}

resource "azurerm_public_ip" "appgateway_beta_public_ip" {
  name                = local.appgateway_beta_public_ip_name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  zones = [1, 2, 3]

  tags = var.tags
}

#
# ⛴ AKS public IP
#
resource "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  name                = "${local.aks_public_ip_name}-${count.index + 1}"
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  sku                 = "Standard"
  allocation_method   = "Static"

  zones = [1, 2, 3]

  tags = var.tags
}
