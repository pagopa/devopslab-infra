module "keda_pod_identity" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity?ref=v2.6.0"

  resource_group_name = "${local.project}-aks-rg"
  location            = var.location
  identity_name       = "${kubernetes_namespace.keda.metadata[0].name}-pod-identity"
  key_vault           = data.azurerm_key_vault.kv
  tenant_id           = data.azurerm_subscription.current.tenant_id
  cluster_name        = data.azurerm_kubernetes_cluster.aks_cluster.name
  namespace           = kubernetes_namespace.keda.metadata[0].name

  secret_permissions = ["get"]
}

resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = "2.6.0"
  namespace  = kubernetes_namespace.keda.metadata[0].name

  set {
    name  = "aadPodIdentity"
    value = "${kubernetes_namespace.keda.metadata[0].name}-pod-identity" # add output in module
  }
}
