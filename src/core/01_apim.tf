# 🔐 KV
data "azurerm_key_vault_secret" "apim_publisher_email" {
  name         = "apim-publisher-email"
  key_vault_id = data.azurerm_key_vault.kv.id
}

#--------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg_api" {
  name     = format("%s-api-rg", local.project)
  location = var.location

  tags = var.tags
}

# APIM subnet
module "apim_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.84"
  name                 = format("%s-apim-snet", local.project)
  resource_group_name  = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.cidr_subnet_apim

  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.Web"]
}


locals {
  apim_cert_name_proxy_endpoint = format("%s-proxy-endpoint-cert", local.project)

  api_domain = format("api.%s.%s", var.dns_zone_prefix, var.external_domain)

  origins = {
    base = concat(
              [
                format("https://api.%s.%s", var.dns_zone_prefix, var.external_domain),
                format("https://%s.%s", var.dns_zone_prefix, var.external_domain),
               ],
               var.env_short != "p"? ["https://localhost:3000","http://localhost:3000","https://localhost:3001","http://localhost:3001"]:[]
            )
  }
}

###########################
## Api Management (apim) ##
###########################

module "apim" {
  source               = "git::https://github.com/pagopa/azurerm.git//api_management?ref=INFRA-316-azurerm-apim-redis-not-mandatory"

  name                 = format("%s-apim", local.project)

  subnet_id            = module.apim_snet.id
  location             = azurerm_resource_group.rg_api.location
  resource_group_name  = azurerm_resource_group.rg_api.name

  publisher_name       = var.apim_publisher_name
  publisher_email      = data.azurerm_key_vault_secret.apim_publisher_email.value
  sku_name             = var.apim_sku
  virtual_network_type = "Internal"

#   redis_connection_string = module.redis.primary_connection_string
#   redis_cache_id          = module.redis.id

  # This enables the Username and Password Identity Provider
  sign_up_enabled = false

  lock_enable = var.lock_enable

  # sign_up_terms_of_service = {
  #   consent_required = false
  #   enabled          = false
  #   text             = ""
  # }

  application_insights_instrumentation_key = data.azurerm_application_insights.application_insights.instrumentation_key

#   xml_content = templatefile("./api/base_policy.tpl", {
#     origins = local.origins.base
#   })

  tags = var.tags

#   depends_on = [
#     azurerm_application_insights.application_insights,
#     module.redis
#   ]
}

# resource "azurerm_api_management_custom_domain" "api_custom_domain" {
#   api_management_id = module.apim.id

#   proxy {
#     host_name = local.api_domain
#     key_vault_id = replace(
#     data.azurerm_key_vault_certificate.app_gw_platform.secret_id,
#     "/${data.azurerm_key_vault_certificate.app_gw_platform.version}",
#     ""
#     )
#   }
# }
