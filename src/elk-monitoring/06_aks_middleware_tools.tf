# module "tls_checker" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//tls_checker?ref=v6.20.1"

#   https_endpoint                             = local.kibana_hostname
#   alert_name                                 = local.kibana_hostname
#   alert_enabled                              = true
#   helm_chart_present                         = true
#   helm_chart_version                         = var.tls_cert_check_helm.chart_version
#   namespace                                  = data.kubernetes_namespace.namespace.metadata[0].name
#   helm_chart_image_name                      = var.tls_cert_check_helm.image_name
#   helm_chart_image_tag                       = var.tls_cert_check_helm.image_tag
#   location_string                            = var.location_string
#   application_insights_connection_string     = data.azurerm_application_insights.application_insights.connection_string
#   application_insights_resource_group        = data.azurerm_resource_group.monitor_rg.name
#   application_insights_id                    = data.azurerm_application_insights.application_insights.id
#   application_insights_action_group_slack_id = data.azurerm_monitor_action_group.slack.id
#   application_insights_action_group_email_id = data.azurerm_monitor_action_group.email.id
# }

module "letsencrypt_dev_elk" {
  source = "git::https://github.com/pagopa/azurerm.git//letsencrypt_credential?ref=v3.8.1"

  prefix            = var.prefix
  env               = var.env_short
  key_vault_name    = "${local.product}-${var.domain}-kv"
  subscription_name = var.subscription_name
}

module "cert_mounter" {
  source           = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v6.20.1"
  namespace        = local.elk_namespace
  certificate_name = replace(local.kibana_hostname, ".", "-")
  kv_name          = module.key_vault.name
  tenant_id        = data.azurerm_subscription.current.tenant_id
}
