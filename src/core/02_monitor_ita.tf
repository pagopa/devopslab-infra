resource "azurerm_resource_group" "monitor_ita_rg" {
  name     = local.monitor_ita_rg_name
  location = var.location_ita

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace_ita" {
  name                = local.monitor_ita_log_analytics_workspace_name
  location            = azurerm_resource_group.monitor_ita_rg.location
  resource_group_name = azurerm_resource_group.monitor_ita_rg.name
  sku                 = var.law_sku
  retention_in_days   = var.law_retention_in_days
  daily_quota_gb      = var.law_daily_quota_gb

  tags = var.tags
}

# Application insights
resource "azurerm_application_insights" "application_insights_ita" {
  name                = local.monitor_ita_appinsights_name
  location            = azurerm_resource_group.monitor_ita_rg.location
  resource_group_name = azurerm_resource_group.monitor_ita_rg.name
  application_type    = "other"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace_ita.id

  tags = var.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "application_insights_ita_key" {
  name         = "appinsights-instrumentation-ita-key"
  value        = azurerm_application_insights.application_insights_ita.instrumentation_key
  content_type = "text/plain"

  key_vault_id = module.key_vault_core_ita.id
}

resource "azurerm_monitor_action_group" "email_ita" {
  name                = "PagoPA"
  resource_group_name = azurerm_resource_group.monitor_ita_rg.name
  short_name          = "PagoPA"

  email_receiver {
    name                    = "sendtooperations"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_email.value
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_action_group" "slack_ita" {
  name                = "SlackPagoPA"
  resource_group_name = azurerm_resource_group.monitor_ita_rg.name
  short_name          = "SlackPagoPA"

  email_receiver {
    name                    = "sendtoslack"
    email_address           = data.azurerm_key_vault_secret.monitor_notification_slack_email.value
    use_common_alert_schema = true
  }

  tags = var.tags
}
