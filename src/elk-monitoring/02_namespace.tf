resource "kubernetes_namespace" "elastic_system" {
  metadata {
    name = local.elk_namespace
  }
  depends_on = [data.azurerm_kubernetes_cluster.aks]
}

module "pod_identity" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_pod_identity?ref=v7.2.0"

  resource_group_name = local.aks_resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id
  cluster_name        = local.aks_name

  identity_name = "${kubernetes_namespace.elastic_system.metadata[0].name}-pod-identity" // TODO add env in name
  namespace     = kubernetes_namespace.elastic_system.metadata[0].name
  key_vault_id  = module.key_vault.id

  secret_permissions      = ["Get"]
  certificate_permissions = ["Get"]

  depends_on = [kubernetes_namespace.elastic_system]
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = kubernetes_namespace.elastic_system.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }

  depends_on = [kubernetes_namespace.elastic_system]

}
