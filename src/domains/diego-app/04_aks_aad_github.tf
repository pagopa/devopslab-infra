data "azuread_service_principal" "github_runner_ci" {
  display_name = "github-pagopa-devopslab-infra-dev-ci"
}

resource "azurerm_role_definition" "pagopa_aks_service_cluster_user_role" {
  name        = "Pagopa Azure Kubernetes Service Cluster User Role"
  scope       = data.azurerm_kubernetes_cluster.aks.id
  description = "AKS user can login to aks and download kubeconfig "
  permissions {
    actions     = [
        "Microsoft.ContainerService/managedClusters/read",
        "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
        "Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action"
        ]
  }
}

resource "azurerm_role_assignment" "aks_service_cluster_user_role_for_github_runner_ci" {
  scope                = data.azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Pagopa Azure Kubernetes Service Cluster User Role"
  principal_id         = data.azuread_service_principal.github_runner_ci.id

  depends_on = [
    azurerm_role_definition.pagopa_aks_service_cluster_user_role
  ]
}

# # this was made because we need a way to achive this role: Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action
# resource "azurerm_role_assignment" "aks_service_rbac_admin_for_github_runner_ci" {
#   scope                = data.azurerm_kubernetes_cluster.aks.id
#   role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
#   principal_id         = data.azuread_service_principal.github_runner_ci.id
# }


resource "azurerm_key_vault_access_policy" "github_runner_ci" {
  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.github_runner_ci.object_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get", ]

  storage_permissions = []
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

# resource "null_resource" "aks_with_iac_aad_plus_namespace_system_ci" {

#   triggers = {
#     aks_id               = data.azurerm_kubernetes_cluster.aks.id
#     service_principal_id = data.azuread_service_principal.github_runner_ci.id
#     namespace            = var.domain
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#       az role assignment create --role "Azure Kubernetes Service RBAC Admin" \
#       --assignee ${self.triggers.service_principal_id} \
#       --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}-system
#     EOT
#   }

#   provisioner "local-exec" {
#     when    = destroy
#     command = <<EOT
#       az role assignment delete --role "Azure Kubernetes Service RBAC Admin" \
#       --assignee ${self.triggers.service_principal_id} \
#       --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}-system
#     EOT
#   }
# }

