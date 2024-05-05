resource "azurerm_resource_group" "monitor_rg" {
  name     = local.monitor_rg_name
  location = var.location

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = local.monitor_log_analytics_workspace_name
  location            = azurerm_resource_group.monitor_rg.location
  resource_group_name = azurerm_resource_group.monitor_rg.name
  sku                 = var.law_sku
  retention_in_days   = var.law_retention_in_days
  daily_quota_gb      = var.law_daily_quota_gb

  tags = var.tags
}

# Application insights
resource "azurerm_application_insights" "application_insights" {
  name                = local.monitor_appinsights_name
  location            = azurerm_resource_group.monitor_rg.location
  resource_group_name = azurerm_resource_group.monitor_rg.name
  application_type    = "other"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tags = var.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "application_insights_key" {
  name         = "appinsights-instrumentation-key"
  value        = azurerm_application_insights.application_insights_ita.instrumentation_key
  content_type = "text/plain"

  key_vault_id = module.key_vault_core_ita.id
}

resource "azurerm_monitor_action_group" "email" {
  name                = "PagoPA"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "PagoPA"

  email_receiver {
    name                    = "sendtooperations"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_email.value
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_action_group" "slack" {
  name                = "SlackPagoPA"
  resource_group_name = azurerm_resource_group.monitor_rg.name
  short_name          = "SlackPagoPA"

  email_receiver {
    name                    = "sendtoslack"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_slack_email.value
    use_common_alert_schema = true
  }

  tags = var.tags
}

# #
# # Monitor storage
# #
# module "security_monitoring_storage" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v8.5.0"
#
#   name                            = local.monitor_security_storage_name
#   account_kind                    = "StorageV2"
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   access_tier                     = "Hot"
#   blob_versioning_enabled         = false
#   resource_group_name             = azurerm_resource_group.monitor_rg.name
#   location                        = var.location
#   advanced_threat_protection      = false
#   allow_nested_items_to_be_public = false
#   public_network_access_enabled   = true
#
#   blob_delete_retention_days = 1
#
#   tags = var.tags
# }
