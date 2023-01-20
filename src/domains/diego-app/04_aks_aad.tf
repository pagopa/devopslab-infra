data "azuread_service_principal" "iac_service_principal" {
  display_name = "pagopaspa-devops-platform-iac-projects-${data.azurerm_subscription.current.subscription_id}"
}

resource "null_resource" "aks_with_iac_aad_plus_namespace" {

  triggers = {
    aks_id = data.azurerm_kubernetes_cluster.aks.id
    service_principal_id = data.azuread_service_principal.iac_service_principal.id
    namespace = var.domain
  }

  provisioner "local-exec" {
    command = <<EOT
      az role assignment create --role "Azure Kubernetes Service RBAC Writer" \
      --assignee ${self.triggers.service_principal_id} \
      --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}
    EOT
  }
}

resource "null_resource" "aks_with_iac_aad_plus_namespace_system" {

  triggers = {
    aks_id = data.azurerm_kubernetes_cluster.aks.id
    service_principal_id = data.azuread_service_principal.iac_service_principal.id
    namespace = var.domain
  }

  provisioner "local-exec" {
    command = <<EOT
      az role assignment create --role "Azure Kubernetes Service RBAC Writer" \
      --assignee ${self.triggers.service_principal_id} \
      --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}-system
    EOT
  }
}
