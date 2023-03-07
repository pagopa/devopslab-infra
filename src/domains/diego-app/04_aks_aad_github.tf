#
# CI
#

data "azuread_service_principal" "github_runner_ci" {
  display_name = "github-pagopa-devopslab-infra-dev-ci"
}

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

#
# CD
#

data "azuread_service_principal" "github_runner_cd" {
  display_name = "github-pagopa-devopslab-infra-dev-cd"
}

resource "azurerm_key_vault_access_policy" "github_runner_cd" {
  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.github_runner_cd.object_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get", ]

  storage_permissions = []
}

resource "azurerm_role_assignment" "aks_cluster_role" {
  scope                = data.azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azuread_service_principal.github_runner_cd.id
}
