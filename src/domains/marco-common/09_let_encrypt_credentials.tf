module "letsencrypt_marco" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v4.1.0"

  prefix            = var.prefix
  env               = var.env_short
  key_vault_name    = module.key_vault_domain.name
  subscription_name = "devopslab"
}
