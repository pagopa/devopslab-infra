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
