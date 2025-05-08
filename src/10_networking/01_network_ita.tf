# resource "azurerm_resource_group" "rg_ita_vnet" {
#   name     = local.vnet_ita_resource_group_name
#   location = var.location_ita
#
#   tags = var.tags
# }
#
# module "vnet_italy" {
#   source = "./.terraform/modules/__v3__/virtual_network"
#
#   name                = local.vnet_ita_name
#   location            = var.location_ita
#   resource_group_name = azurerm_resource_group.rg_ita_vnet.name
#
#   address_space        = var.cidr_vnet_italy
#   ddos_protection_plan = var.vnet_ita_ddos_protection_plan
#
#   tags = var.tags
# }
#
# ## Peering between the vnet(main) and italy vnet
# module "vnet_ita_peering" {
#   source = "./.terraform/modules/__v3__/virtual_network_peering"
#
#   source_resource_group_name       = azurerm_resource_group.rg_ita_vnet.name
#   source_virtual_network_name      = module.vnet_italy.name
#   source_remote_virtual_network_id = module.vnet_italy.id
#   source_use_remote_gateways       = false
#   source_allow_forwarded_traffic   = true
#
#   target_resource_group_name       = azurerm_resource_group.rg_vnet.name
#   target_virtual_network_name      = module.vnet.name
#   target_remote_virtual_network_id = module.vnet.id
#   target_allow_gateway_transit     = false
# }
#
# module "packer_azdo_snet" {
#   source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet"
#   name                                      = "packer-azdo-subnet"
#   address_prefixes                          = var.cidr_subnet_packer_azdo
#   virtual_network_name                      = module.vnet_italy.name
#   resource_group_name                       = azurerm_resource_group.rg_ita_vnet.name
#   service_endpoints                         = []
#   private_endpoint_network_policies_enabled = true
# }
#
# module "packer_dns_forwarder_snet" {
#   source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet"
#   name                                      = "packer-dns-forwarder-subnet"
#   address_prefixes                          = var.cidr_subnet_packer_dns_forwarder
#   virtual_network_name                      = module.vnet_italy.name
#   resource_group_name                       = azurerm_resource_group.rg_ita_vnet.name
#   service_endpoints                         = []
#   private_endpoint_network_policies_enabled = true
# }
