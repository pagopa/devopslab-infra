module "firewall_snet" {
  source                                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.10.1"
  name                                          = "AzureFirewallSubnet"
  address_prefixes                              = var.cidr_firewall_subnet
  resource_group_name                           = local.vnet_core_resource_group_name
  virtual_network_name                          = local.vnet_core_name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}

module "firewall_mng_snet" {
  source                                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.10.1"
  name                                          = "AzureFirewallManagementSubnet"
  address_prefixes                              = var.cidr_firewall_mng_subnet
  resource_group_name                           = local.vnet_core_resource_group_name
  virtual_network_name                          = local.vnet_core_name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}
