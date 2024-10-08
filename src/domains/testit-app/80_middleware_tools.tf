module "tls_checker" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//tls_checker?ref=v8.38.0"

  https_endpoint                                            = local.domain_aks_hostname
  alert_name                                                = local.domain_aks_hostname
  alert_enabled                                             = true
  helm_chart_present                                        = true
  namespace                                                 = kubernetes_namespace.domain_namespace.metadata[0].name
  location_string                                           = var.location
  kv_secret_name_for_application_insights_connection_string = "dvopla-d-itn-appinsights-connection-string"
  keyvault_name                                             = data.azurerm_key_vault.kv_domain.name
  keyvault_tenant_id                                        = data.azurerm_client_config.current.tenant_id
  application_insights_resource_group                       = data.azurerm_resource_group.monitor_rg.name
  application_insights_id                                   = data.azurerm_application_insights.application_insights.id
  application_insights_action_group_ids                     = [data.azurerm_monitor_action_group.slack.id, data.azurerm_monitor_action_group.email.id]

  workload_identity_enabled              = true
  workload_identity_service_account_name = module.workload_identity_configuration.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity_configuration.workload_identity_client_id
}

module "cert_mounter" {
  source                                 = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v8.38.0"
  namespace                              = var.domain
  certificate_name                       = replace(local.domain_aks_hostname, ".", "-")
  kv_name                                = data.azurerm_key_vault.kv_domain.name
  tenant_id                              = data.azurerm_subscription.current.tenant_id
  workload_identity_enabled              = true
  workload_identity_service_account_name = module.workload_identity_configuration.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity_configuration.workload_identity_client_id
}
