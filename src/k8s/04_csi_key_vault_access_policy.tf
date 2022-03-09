resource "azurerm_key_vault_access_policy" "cluster_access_policy" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = "25859118-4d19-418a-97ff-97af3a4ca929"

  secret_permissions = ["get"]
}
