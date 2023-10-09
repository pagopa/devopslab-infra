resource "azurerm_resource_group" "rg_vnet" {
  name     = "${local.project}-vnet-rg"
  location = var.location

  tags = var.tags
}

module "vnet_hub" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v7.10.1"
  name                = "${local.project}-hub-vnet"
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_hub_vnet

  tags = var.tags
}

module "firewall_snet" {
  source                                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.10.1"
  name                                          = "AzureFirewallSubnet"
  address_prefixes                              = var.cidr_firewall_subnet
  resource_group_name                           = module.vnet_hub.resource_group_name
  virtual_network_name                          = module.vnet_hub.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}

module "firewall_mng_snet" {
  source                                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.10.1"
  name                                          = "AzureFirewallManagementSubnet"
  address_prefixes                              = var.cidr_firewall_mng_subnet
  resource_group_name                           = module.vnet_hub.resource_group_name
  virtual_network_name                          = module.vnet_hub.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}


module "vnet_hub_core_peering" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v7.10.1"

  location = azurerm_resource_group.rg_vnet.location

  source_resource_group_name       = azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = module.vnet_hub.name
  source_remote_virtual_network_id = module.vnet_hub.id

  source_allow_virtual_network_access = true
  source_allow_forwarded_traffic      = true
  source_allow_gateway_transit        = true
  source_use_remote_gateways          = false

  target_allow_virtual_network_access = true
  target_allow_forwarded_traffic      = true
  target_allow_gateway_transit        = false
  target_use_remote_gateways          = true

  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet_app.name
  target_remote_virtual_network_id = module.vnet_app.id

}


