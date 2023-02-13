data "azuread_service_principal" "github_runner_ci" {
  display_name = "github-pagopa-devopslab-infra-dev-ci"
}

resource "null_resource" "aks_with_iac_aad_plus_namespace_ci" {

  triggers = {
    aks_id               = data.azurerm_kubernetes_cluster.aks.id
    service_principal_id = data.azuread_service_principal.github_runner_ci.id
    namespace            = var.domain
  }

  provisioner "local-exec" {
    command = <<EOT
      az role assignment create --role "Azure Kubernetes Service RBAC Admin" \
      --assignee ${self.triggers.service_principal_id} \
      --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      az role assignment delete --role "Azure Kubernetes Service RBAC Admin" \
      --assignee ${self.triggers.service_principal_id} \
      --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}
    EOT
  }
}

resource "null_resource" "aks_with_iac_aad_plus_namespace_system_ci" {

  triggers = {
    aks_id               = data.azurerm_kubernetes_cluster.aks.id
    service_principal_id = data.azuread_service_principal.github_runner_ci.id
    namespace            = var.domain
  }

  provisioner "local-exec" {
    command = <<EOT
      az role assignment create --role "Azure Kubernetes Service RBAC Admin" \
      --assignee ${self.triggers.service_principal_id} \
      --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}-system
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      az role assignment delete --role "Azure Kubernetes Service RBAC Admin" \
      --assignee ${self.triggers.service_principal_id} \
      --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}-system
    EOT
  }
}
