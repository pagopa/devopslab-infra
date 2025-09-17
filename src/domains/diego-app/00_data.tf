#---------------------------------------------------------------
# AKS Cluster Data Source
#---------------------------------------------------------------
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.aks_resource_group_name
}

#---------------------------------------------------------------
# Azure AD Groups Data Sources
#---------------------------------------------------------------
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

#---------------------------------------------------------------
# Key Vault Data Source
#---------------------------------------------------------------
data "azurerm_key_vault" "kv_domain" {
  name                = local.key_vault_domain_name
  resource_group_name = local.key_vault_domain_resource_group
}

data "azurerm_key_vault_secret" "argocd_admin_username" {
  name         = "argocd-admin-username"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

data "azurerm_key_vault_secret" "argocd_admin_password" {
  name         = "argocd-admin-password"
  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

#---------------------------------------------------------------
# Monitoring Data Sources
#---------------------------------------------------------------
data "azurerm_resource_group" "monitor_rg" {
  name = var.monitor_resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.monitor_appinsights_name
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_email_name
}

#---------------------------------------------------------------
# Network Data Sources
#---------------------------------------------------------------
data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_resource_group" "rg_vnet_core" {
  name = local.vnet_core_resource_group_name
}
