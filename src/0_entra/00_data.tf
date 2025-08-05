#
# 🔐 KV
#
data "azurerm_key_vault" "kv_core_ita" {
  name                = "dvopla-d-itn-core-kv"
  resource_group_name = "dvopla-d-itn-sec-rg"
}

#
# Users
#
data "azuread_users" "argocd_application_owners" {
  user_principal_names = local.argocd_application_owners
}

#
# Kubernetes
#
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.kubernetes_cluster_name
  resource_group_name = local.kubernetes_cluster_resource_group_name
}

# -----------------------------------------------------------------------------
# Entra ID Data Sources
# -----------------------------------------------------------------------------

data "azuread_service_principal" "graph" {
  display_name = "Microsoft Graph"
}

# data "azurerm_client_config" "current" {}

data "azuread_group" "argocd_groups" {
  for_each     = toset(var.argocd_entra_groups_allowed)
  display_name = each.value
}
