# # 🔐 KV
# data "azurerm_key_vault_secret" "apim_publisher_email" {
#   name         = "apim-publisher-email"
#   key_vault_id = module.key_vault_core_ita.id
# }
#
# ## 🎫  Certificates
#
# data "azurerm_key_vault_certificate" "apim_internal_certificate" {
#   name         = var.apim_api_internal_certificate_name
#   key_vault_id = module.key_vault_core_ita.id
# }
#
# #--------------------------------------------------------------------------------------------------
#
# resource "azurerm_resource_group" "rg_api" {
#   name     = "${local.project_ita}-api-rg"
#   location = var.location_ita
#
#   tags = var.tags
# }
#
# # APIM subnet
# module "apim_snet" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v8.5.0"
#   count  = var.apim_enabled == true ? 1 : 0
#
#   name                 = "${local.project_ita}-apim-snet"
#   resource_group_name  = azurerm_resource_group.rg_ita_vnet.name
#   virtual_network_name = module.vnet_italy.name
#   address_prefixes     = var.cidr_subnet_apim
#
#   private_endpoint_network_policies_enabled = true
# }
#
# module "apim_stv2_snet" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v8.5.0"
#   count  = var.apim_enabled == true ? 1 : 0
#
#   name                 = "${local.project_ita}-apim-stv2-snet"
#   resource_group_name  = azurerm_resource_group.rg_vnet.name
#   virtual_network_name = module.vnet_italy.name
#   address_prefixes     = var.cidr_subnet_apim_stv2
#
#   private_endpoint_network_policies_enabled = true
# }
#
# resource "azurerm_network_security_group" "apim_snet_nsg" {
#   name                = "apim-snet-nsg"
#   location            = var.location_ita
#   resource_group_name = azurerm_resource_group.rg_vnet.name
# }
#
# resource "azurerm_network_security_rule" "apim_snet_nsg_rules" {
#   count = length(var.apim_subnet_nsg_security_rules)
#
#   network_security_group_name = azurerm_network_security_group.apim_snet_nsg.name
#   name                        = var.apim_subnet_nsg_security_rules[count.index].name
#   resource_group_name         = azurerm_resource_group.rg_vnet.name
#   priority                    = var.apim_subnet_nsg_security_rules[count.index].priority
#   direction                   = var.apim_subnet_nsg_security_rules[count.index].direction
#   access                      = var.apim_subnet_nsg_security_rules[count.index].access
#   protocol                    = var.apim_subnet_nsg_security_rules[count.index].protocol
#   source_port_range           = var.apim_subnet_nsg_security_rules[count.index].source_port_range
#   destination_port_range      = var.apim_subnet_nsg_security_rules[count.index].destination_port_range
#   source_address_prefix       = var.apim_subnet_nsg_security_rules[count.index].source_address_prefix
#   destination_address_prefix  = var.apim_subnet_nsg_security_rules[count.index].destination_address_prefix
# }
#
# resource "azurerm_subnet_network_security_group_association" "apim_stv2_snet" {
#   count = var.apim_enabled == true ? 1 : 0
#
#   subnet_id                 = module.apim_stv2_snet[0].id
#   network_security_group_id = azurerm_network_security_group.apim_snet_nsg.id
# }
#
# resource "azurerm_subnet_network_security_group_association" "apim_snet" {
#   count = var.apim_enabled == true ? 1 : 0
#
#   subnet_id                 = module.apim_snet[0].id
#   network_security_group_id = azurerm_network_security_group.apim_snet_nsg.id
# }
#
# #--------------------------------------------------------------------------------------------------
#
# ###########################
# ## Api Management (apim) ##
# ###########################
#
# module "apim" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management?ref=v8.5.0"
#   count  = var.apim_enabled == true ? 1 : 0
#
#   name = "${local.project_ita}-apim"
#
#   subnet_id           = module.apim_snet[0].id
#   location            = azurerm_resource_group.rg_api.location
#   resource_group_name = azurerm_resource_group.rg_api.name
#
#   publisher_name       = var.apim_publisher_name
#   publisher_email      = data.azurerm_key_vault_secret.apim_publisher_email.value
#   sku_name             = var.apim_sku
#   virtual_network_type = "Internal"
#
#   redis_connection_string = null
#   redis_cache_id          = null
#
#   # This enables the Username and Password Identity Provider
#   sign_up_enabled = false
#
#   application_insights = {
#     enabled             = true
#     instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
#   }
#
#   tags = var.tags
# }
#
# #
# # 🔐 Key Vault Access Policies
# #
#
# ## api management policy ##
# resource "azurerm_key_vault_access_policy" "api_management_policy" {
#   count = var.apim_enabled == true ? 1 : 0
#
#   key_vault_id = module.key_vault_core_ita.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = module.apim[0].principal_id
#
#   key_permissions         = []
#   secret_permissions      = ["Get", "List"]
#   certificate_permissions = ["Get", "List"]
#   storage_permissions     = []
# }
#
# #
# # 🏷 custom domain
# #
# resource "azurerm_api_management_custom_domain" "api_custom_domain" {
#   count = var.apim_enabled == true ? 1 : 0
#
#   api_management_id = module.apim[0].id
#
#   gateway {
#     host_name = local.api_internal_domain
#     key_vault_id = replace(
#       data.azurerm_key_vault_certificate.apim_internal_certificate.secret_id,
#       "/${data.azurerm_key_vault_certificate.apim_internal_certificate.version}",
#       ""
#     )
#   }
# }
#
# # api.internal.*.userregistry.pagopa.it
# resource "azurerm_private_dns_a_record" "api_internal" {
#   count = var.apim_enabled == true ? 1 : 0
#
#
#   name    = "api"
#   records = module.apim[0].*.private_ip_addresses[0]
#   ttl     = var.dns_default_ttl_sec
#
#   zone_name           = azurerm_private_dns_zone.internal_devopslab[0].name
#   resource_group_name = azurerm_resource_group.rg_vnet.name
#   tags                = var.tags
# }
