data "azurerm_key_vault_secret" "sftp_account_name" {
  name         = "sftp-azurestorageaccountname"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sftp_account_key" {
  name         = "sftp-azurestorageaccountkey"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sftp_private_key" {
  name         = "sftp-privatekey"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "grafana_admin_username" {
  name         = "grafana-admin-username"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "grafana_admin_password" {
  name         = "grafana-admin-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

