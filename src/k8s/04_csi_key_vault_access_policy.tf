locals {
  secrets_provider = data.azurerm_kubernetes_cluster.aks_cluster.addon_profile[0].azure_keyvault_secrets_provider[0]
}

resource "azurerm_key_vault_access_policy" "cluster_access_policy" {
  count = local.secrets_provider.enabled ? 1 : 0

  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = local.secrets_provider.secret_identity[0].object_id

  secret_permissions = ["get"]
}
