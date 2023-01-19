module "keda_pod_identity" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity?ref=v4.1.0"

  resource_group_name = "${local.project}-aks-rg"
  location            = var.location
  identity_name       = "${kubernetes_namespace.keda.metadata[0].name}-pod-identity"
  cluster_name        = module.aks.name
  namespace           = kubernetes_namespace.keda.metadata[0].name
  tenant_id           = data.azurerm_subscription.current.tenant_id
}

resource "azurerm_role_assignment" "keda_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = module.keda_pod_identity.identity.principal_id
}

resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = "2.6.0"
  namespace  = kubernetes_namespace.keda.metadata[0].name

  set {
    name  = "podIdentity.activeDirectory.identity"
    value = "${kubernetes_namespace.keda.metadata[0].name}-pod-identity"
  }
}
