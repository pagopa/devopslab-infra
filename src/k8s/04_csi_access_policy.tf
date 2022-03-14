resource "azurerm_key_vault_access_policy" "cluster_access_policy" {
  count = local.aks_secrets_provider.enabled ? 1 : 0

  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = local.aks_secrets_provider.secret_identity[0].object_id

  secret_permissions = ["get"]
}
