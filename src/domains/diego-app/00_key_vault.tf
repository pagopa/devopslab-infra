data "azurerm_key_vault" "kv_domain" {
  name                = local.key_vault_domain_name
  resource_group_name = local.key_vault_domain_resource_group
}

