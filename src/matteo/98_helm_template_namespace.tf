resource "kubernetes_namespace" "helm_template" {
  metadata {
    name = "helm-template"
  }
}

module "namespace_pod_identity" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity?ref=v2.15.1"

  resource_group_name = "${local.project}-aks-rg"

  location      = var.location
  identity_name = "${kubernetes_namespace.helm_template.metadata[0].name}-pod-identity"
  key_vault     = data.azurerm_key_vault.kv
  tenant_id     = data.azurerm_subscription.current.tenant_id
  cluster_name  = module.aks.name
  namespace     = kubernetes_namespace.helm_template.metadata[0].name

  secret_permissions = ["get"]
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v0.0.109"
  namespace  = kubernetes_namespace.helm_template.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
