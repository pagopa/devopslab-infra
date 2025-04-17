resource "kubernetes_namespace" "elastic_system" {
  metadata {
    name = local.elk_namespace
  }
  depends_on = [data.azurerm_kubernetes_cluster.aks]
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

resource "helm_release" "kube_state_metrics" {
  name       = "kube-state-metrics"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"
  version    = "5.10.1"
  namespace  = kubernetes_namespace.elastic_system.metadata[0].name

}
