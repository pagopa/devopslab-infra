// ⚠️ Manual step required after apply:
// App > API permissions > Microsoft Graph > User.Read > Grant admin consent

module "argocd_entra" {
  source = "./modules/argocd_entra"

  prefix                      = var.prefix
  argocd_hostname             = local.argocd_hostname
  owners_object_ids           = data.azuread_users.argocd_application_owners.object_ids
  group_display_names         = var.argocd_entra_groups_allowed
  project                     = local.project
  aks_name                    = local.kubernetes_cluster_name
  aks_resource_group_name     = local.kubernetes_cluster_resource_group_name
  argocd_namespace            = local.argocd_namespace
  argocd_service_account_name = local.argocd_service_account_name
  key_vault_id                = data.azurerm_key_vault.kv_core_ita.id
}
