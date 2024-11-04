data "azurerm_key_vault_secret" "kubecost-token" {
  key_vault_id = data.azurerm_key_vault.common_key_vault.id
  name         = "kubecost-ff-token"
}
