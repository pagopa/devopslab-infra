resource "azurerm_resource_group" "rg_vnet" {
  name     = local.vnet_resource_group_name
  location = var.location

  tags = var.tags
}

#
# vnet
#
module "vnet" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v8.13.0"
  name                = local.vnet_name
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_vnet

  tags = var.tags
}


#
# Public IP
#

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

resource "azurerm_public_ip" "apim_management_public_ip" {
  name                = local.apim_management_public_ip_name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  domain_name_label = "dvopla-d-apim-management"

  zones = [1, 2, 3]

  tags = var.tags
}

resource "azurerm_public_ip" "apim_management_public_ip_2" {
  name                = local.apim_management_public_ip_name_2
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  domain_name_label = "dvopla-d-apim-management-2"

  zones = [1, 2, 3]

  tags = var.tags
}

#
# ⛴ AKS public IP
#
resource "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  name                = "${local.aks_public_ip_name}-${count.index + 1}"
  location            = var.location_ita
  resource_group_name = azurerm_resource_group.rg_ita_vnet.name
  sku                 = "Standard"
  allocation_method   = "Static"

  zones = [1, 2, 3]

  tags = var.tags
}

#
# Private endpoints
#
module "private_endpoints_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v8.13.0"
  name                 = "${local.project}-private-endpoints-snet"
  address_prefixes     = var.cidr_subnet_private_endpoints
  virtual_network_name = module.vnet.name

  resource_group_name = azurerm_resource_group.rg_vnet.name

  private_endpoint_network_policies_enabled = false
  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Storage",
  ]
}
