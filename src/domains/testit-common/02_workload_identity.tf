module "workload_identity_init" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = var.domain
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  workload_identity_location            = var.location
}
