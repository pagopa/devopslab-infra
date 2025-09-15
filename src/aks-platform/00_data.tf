### Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}

data "azuread_group" "adgroup_operations" {
  display_name = "${local.product}-adgroup-operations"
}

data "azuread_group" "adgroup_technical_project_managers" {
  display_name = "${local.product}-adgroup-technical-project-managers"
}

### Azure Container Registry
data "azurerm_container_registry" "acr" {
  name                = local.docker_registry_name
  resource_group_name = local.docker_rg_name
}

### Azure Key Vault
data "azurerm_key_vault" "kv_core_ita" {
  name                = "dvopla-d-itn-core-kv"
  resource_group_name = "dvopla-d-itn-sec-rg"
}

### 🔭 Monitor
data "azurerm_resource_group" "rg_monitor" {
  name = local.monitor_rg_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.monitor_appinsights_name
  resource_group_name = data.azurerm_resource_group.rg_monitor.name
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = local.monitor_log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.rg_monitor.name
}

# ⚡️ monitor action groups

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = local.monitor_rg_name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = local.monitor_rg_name
  name                = local.monitor_action_group_email_name
}

# # monitoring storage
# data "azurerm_storage_account" "security_monitoring_storage" {
#   name                = local.monitor_security_storage_name
#   resource_group_name = data.azurerm_resource_group.rg_monitor.name
# }

