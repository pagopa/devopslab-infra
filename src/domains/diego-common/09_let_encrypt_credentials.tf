module "letsencrypt_diego" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v3.15.0"

  prefix            = "dvopla"
  env               = "d"
  key_vault_name    = "dvopla-d-diego-kv"
  subscription_name = "devopslab"
}
