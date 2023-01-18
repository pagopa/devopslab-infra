module "letsencrypt_diego" {
  source = "git::https://github.com/pagopa/azurerm.git//letsencrypt_credential?ref=version-unlocked"

  prefix            = "dvopla"
  env               = "d"
  key_vault_name    = "dvopla-d-diego-kv"
  subscription_name = "devopslab"
}
