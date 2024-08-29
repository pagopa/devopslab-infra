resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }

  depends_on = [
    module.aks
  ]
}

locals {
  keda_namespace_name = kubernetes_namespace.keda.metadata[0].name
}

module "keda_workload_identity" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity?ref=aks-allow-remove-pod-identity"

  workload_name_prefix                  = "keda"
  workload_identity_resource_group_name = azurerm_resource_group.rg_aks.name
  aks_name                              = module.aks.name
  aks_resource_group_name               = azurerm_resource_group.rg_aks.name
  namespace                             = kubernetes_namespace.keda.metadata[0].name

  key_vault_id                      = data.azurerm_key_vault.kv_core_ita.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]
}

resource "azurerm_role_assignment" "keda_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = module.keda_workload_identity.workload_identity_principal_id

  depends_on = [
    module.aks
  ]
}

resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = var.keda_helm_version
  namespace  = kubernetes_namespace.keda.metadata[0].name
  wait       = false

  set {
    name  = "podIdentity.provider"
    value = "azure-workload"
  }

  set {
    name  = "podIdentity.identityId"
    value = module.keda_workload_identity.workload_identity_client_id
  }

  set {
    name  = "podIdentity.identityTenantId"
    value = data.azurerm_client_config.current.tenant_id
  }

  depends_on = [
    module.aks
  ]
}
