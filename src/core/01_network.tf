resource "azurerm_resource_group" "rg_vnet" {
  name     = local.vnet_resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_ita_vnet" {
  name     = "${local.project_ita}-vnet-rg"
  location = var.location_ita

  tags = var.tags
}

#
# vnet
#
module "vnet" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v7.70.1"
  name                = local.vnet_name
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_vnet

  tags = var.tags
}

module "vnet_italy" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v7.70.1"

  name                = "${local.project_ita}-vnet"
  location            = var.location_ita
  resource_group_name = azurerm_resource_group.rg_ita_vnet.name

  address_space        = var.cidr_vnet_italy
  ddos_protection_plan = var.vnet_ita_ddos_protection_plan

  tags = var.tags
}

## Peering between the vnet(main) and italy vnet
module "vnet_ita_peering" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v7.70.1"

  source_resource_group_name       = azurerm_resource_group.rg_ita_vnet.name
  source_virtual_network_name      = module.vnet_italy.name
  source_remote_virtual_network_id = module.vnet_italy.id
  source_use_remote_gateways       = false
  source_allow_forwarded_traffic   = true

  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet.name
  target_remote_virtual_network_id = module.vnet.id
  target_allow_gateway_transit     = true

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
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.70.1"
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

module "private_endpoints_italy_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.70.1"
  name                 = "${local.project}-private-endpoints-italy-snet"
  address_prefixes     = var.cidr_subnet_private_endpoints_italy
  virtual_network_name = module.vnet_italy.name

  resource_group_name = azurerm_resource_group.rg_ita_vnet.name

  private_endpoint_network_policies_enabled = false
  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Storage",
  ]
}
