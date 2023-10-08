resource "azurerm_resource_group" "rg_vnet" {
  name     = format("%s-vnet-rg", local.project)
  location = var.location

  tags = var.tags
}

# vnet
module "vnet_ft" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v5.5.2"
  name                = format("%s-frontend-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_frontend_vnet

  tags = var.tags
}

module "vnet_app" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v5.5.2"
  name                = format("%s-application-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_application_vnet

  tags = var.tags
}

module "vnet_data" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v5.5.2"
  name                = format("%s-data-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_data_vnet

  tags = var.tags
}

module "vnet_hub" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v5.5.2"
  name                = format("%s-hub-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_hub_vnet

  tags = var.tags
}

module "firewall_snet" {
  source                                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.5.2"
  name                                          = "AzureFirewallSubnet"
  address_prefixes                              = var.cidr_firewall_subnet
  resource_group_name                           = module.vnet_hub.resource_group_name
  virtual_network_name                          = module.vnet_hub.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}

module "firewall_mng_snet" {
  source                                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.5.2"
  name                                          = "AzureFirewallManagementSubnet"
  address_prefixes                              = var.cidr_firewall_mng_subnet
  resource_group_name                           = module.vnet_hub.resource_group_name
  virtual_network_name                          = module.vnet_hub.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}




module "vnet_hub_ft_peering" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v5.5.2"

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
  target_virtual_network_name      = module.vnet_ft.name
  target_remote_virtual_network_id = module.vnet_ft.id

}

module "vnet_hub_app_peering" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v5.5.2"

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

module "vnet_hub_data_peering" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v5.5.2"

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
  target_virtual_network_name      = module.vnet_data.name
  target_remote_virtual_network_id = module.vnet_data.id

}

# APIM subnet
module "apim_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.5.2"
  name                                      = format("%s-apim-snet", local.project)
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_ft.name
  address_prefixes                          = var.cidr_subnet_apim
  private_endpoint_network_policies_enabled = true

  service_endpoints = ["Microsoft.Web"]
}

module "appgateway_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.5.2"
  name                                      = format("%s-appgateway-snet", local.project)
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_ft.name
  address_prefixes                          = var.cidr_subnet_appgateway
  private_endpoint_network_policies_enabled = true

}

module "vdi_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.5.2"
  name                                      = "${local.project}-vdi-snet"
  address_prefixes                          = var.cidr_subnet_vdi
  resource_group_name                       = module.vnet_hub.resource_group_name
  virtual_network_name                      = module.vnet_hub.name
  private_endpoint_network_policies_enabled = true
}
