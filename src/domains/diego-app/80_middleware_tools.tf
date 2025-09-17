module "cert_mounter" {
  # source           = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v8.42.1"
  source = "./.terraform/modules/__v4__/cert_mounter"

  namespace        = var.domain
  certificate_name = replace(local.domain_aks_hostname, ".", "-")
  kv_name          = data.azurerm_key_vault.kv_domain.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_service_account_name = module.workload_identity.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity.workload_identity_client_id

}
