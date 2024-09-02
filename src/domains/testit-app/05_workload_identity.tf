module "workload_identity" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity?ref=v8.42.0"

  workload_name_prefix                  = var.domain
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = var.domain

  key_vault_id                      = data.azurerm_key_vault.kv_domain.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]
}
