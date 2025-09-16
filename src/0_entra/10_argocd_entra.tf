// ⚠️ Manual step required after apply:
// App > API permissions > Microsoft Graph > User.Read > Grant admin consent

module "argocd_entra" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//kubernetes_argocd_entra?ref=PAYMCLOUD-231-argocd-creazione-modulo"

  name_identifier             = local.project
  argocd_hostname             = local.argocd_hostname
  entra_app_owners_object_ids = data.azuread_users.argocd_application_owners.object_ids
  entra_group_display_names   = var.argocd_entra_groups_allowed
  aks_name                    = local.kubernetes_cluster_name
  aks_resource_group_name     = local.kubernetes_cluster_resource_group_name
  argocd_namespace            = local.argocd_namespace
  argocd_service_account_name = local.argocd_service_account_name
  key_vault_id                = data.azurerm_key_vault.kv_core_ita.id

  tags = module.tag_config.tags
}
