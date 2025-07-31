data "azuread_users" "argocd_application_owners" {
  user_principal_names = local.argocd_application_owners
}
