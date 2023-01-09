### Frontend common resources
resource "azurerm_resource_group" "devopslab_cdn_rg" {
  name     = "${local.project}-selfcare-fe-rg"
  location = var.location

  tags = var.tags
}

### Frontend resources
#tfsec:ignore:azure-storage-queue-services-logging-enabled:exp:2022-05-01 # already ignored, maybe a bug in tfsec
module "devopslab_cdn" {
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cdn?ref=cdn-migrate-from-v2"

  name                  = "devopslab"
  prefix                = local.project
  resource_group_name   = azurerm_resource_group.devopslab_cdn_rg.name
  location              = azurerm_resource_group.devopslab_cdn_rg.location
  hostname              = "cdn.devopslab.pagopa.it"
  https_rewrite_enabled = true

  index_document     = "index.html"
  error_404_document = "404.html"

  dns_zone_name                = azurerm_dns_zone.public.name
  dns_zone_resource_group_name = azurerm_resource_group.rg_vnet.name

  keyvault_vault_name          = data.azurerm_key_vault.kv.name
  keyvault_resource_group_name = var.key_vault_rg_name
  keyvault_subscription_id     = data.azurerm_subscription.current.subscription_id

  querystring_caching_behaviour = "BypassCaching"

  global_delivery_rule = {
    cache_expiration_action       = []
    cache_key_query_string_action = []
    modify_request_header_action  = []

    # HSTS
    modify_response_header_action = [{
      action = "Overwrite"
      name   = "Strict-Transport-Security"
      value  = "max-age=31536000"
      },
      # Content-Security-Policy (in Report mode)
      {
        action = "Append"
        name   = "Content-Security-Policy-Report-Only"
        value  = "script-src 'self' https://www.google.com https://www.gstatic.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; worker-src 'none'; font-src 'self' https://fonts.googleapis.com https://fonts.gstatic.com; "
      },
      {
        action = "Append"
        name   = "Content-Security-Policy-Report-Only"
        value  = "img-src 'self' https://assets.cdn.io.italia.it data:; "
      }
    ]
  }

  tags = var.tags
}
