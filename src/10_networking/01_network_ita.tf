resource "azurerm_resource_group" "rg_ita_vnet" {
  name     = local.vnet_resource_group_name
  location = var.location

  tags = var.tags
}

module "vnet_italy" {
  source = "./.terraform/modules/__v4__/virtual_network"

  name                = "${local.project}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_ita_vnet.name

  address_space        = var.cidr_vnet_italy
  ddos_protection_plan = var.vnet_ita_ddos_protection_plan

  tags = var.tags
}

## Peering between the vnet(main) and italy vnet
module "vnet_ita_peering" {
  source = "./.terraform/modules/__v4__/virtual_network_peering"

  source_resource_group_name       = azurerm_resource_group.rg_ita_vnet.name
  source_virtual_network_name      = module.vnet_italy.name
  source_remote_virtual_network_id = module.vnet_italy.id
  source_use_remote_gateways       = false
  source_allow_forwarded_traffic   = true
  source_allow_gateway_transit     = true

  target_resource_group_name       = data.azurerm_virtual_network.vnet_legacy.resource_group_name
  target_virtual_network_name      = data.azurerm_virtual_network.vnet_legacy.name
  target_remote_virtual_network_id = data.azurerm_virtual_network.vnet_legacy.id
  target_allow_gateway_transit     = false
  target_use_remote_gateways       = true
}

module "packer_azdo_snet" {
  # source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet"
  source = "./.terraform/modules/__v4__/subnet"

  name                                          = "packer-azdo-subnet"
  address_prefixes                              = var.cidr_subnet_packer_azdo
  virtual_network_name                          = module.vnet_italy.name
  resource_group_name                           = azurerm_resource_group.rg_ita_vnet.name
  service_endpoints                             = []
  private_link_service_network_policies_enabled = true

}

module "packer_dns_forwarder_snet" {
  # source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet"
  source = "./.terraform/modules/__v4__/subnet"

  name                                          = "packer-dns-forwarder-subnet"
  address_prefixes                              = var.cidr_subnet_packer_dns_forwarder
  virtual_network_name                          = module.vnet_italy.name
  resource_group_name                           = azurerm_resource_group.rg_ita_vnet.name
  service_endpoints                             = []
  private_link_service_network_policies_enabled = true
}
