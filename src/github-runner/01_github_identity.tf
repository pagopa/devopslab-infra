data "azurerm_kubernetes_cluster" "aks" {
  name                = "${local.product}-itn-dev-aks"
  resource_group_name = "${local.product}-itn-dev-aks-rg"
}

# repos must be lower than 20 items
locals {
  repos_01 = [
    "devops-app-status",
  ]

  federations_01 = [
    for repo in local.repos_01 : {
      repository = repo
      subject    = "github-${var.env}"
    }
  ]

  namespace = "test-app-status"

  # to avoid subscription Contributor -> https://github.com/microsoft/azure-container-apps/issues/35
  environment_cd_roles = {
    subscription = [
      "Reader"
    ]
    resource_groups = {
      "${azurerm_resource_group.rg_github_runner.name}" = [
        "Key Vault Reader"
      ],
      "${data.azurerm_kubernetes_cluster.aks.resource_group_name}" = [
        "Reader",
        "Azure Kubernetes Service Cluster User Role"
      ],
      "${azurerm_resource_group.rg_github_runner.name}" = [
        "Reader"
      ]
    }
  }
}

module "identity_cd_01" {
  source = "./.terraform/modules/__v3__/github_federated_identity"
  # pagopa-<ENV><DOMAIN>-<COUNTER>-github-<PERMS>-identity
  prefix    = var.prefix
  env_short = var.env_short

  identity_role = "cd"

  github_federations = local.federations_01

  cd_rbac_roles = {
    subscription_roles = local.environment_cd_roles.subscription
    resource_groups    = local.environment_cd_roles.resource_groups
  }

  tags = var.tags

}

resource "azurerm_key_vault_access_policy" "gha_iac_managed_identities" {
  key_vault_id = data.azurerm_key_vault.key_vault_common.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.identity_cd_01.identity_principal_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]
  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "GetRotationPolicy"]

  storage_permissions = []
}

resource "null_resource" "github_runner_app_permissions_to_namespace_cd_01" {
  triggers = {
    aks_id               = data.azurerm_kubernetes_cluster.aks.id
    service_principal_id = module.identity_cd_01.identity_client_id
    namespace            = local.namespace
    version              = "v2"
  }

  provisioner "local-exec" {
    command = <<EOT
      az role assignment create --role "Azure Kubernetes Service RBAC Admin" \
      --assignee ${self.triggers.service_principal_id} \
      --scope ${self.triggers.aks_id}/namespaces/${self.triggers.namespace}

      az role assignment list --role "Azure Kubernetes Service RBAC Admin"  \
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

  depends_on = [
    module.identity_cd_01
  ]
}
