module "letsencrypt_diego" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v8.21.0"

  prefix            = "dvopla"
  env               = "d"
  key_vault_name    = module.key_vault_domain.name
  subscription_name = "devopslab"
}
