resource "kubernetes_namespace" "costs_monitoring" {
  metadata {
    name = local.costs_monitoring_namespace
  }
  depends_on = [data.azurerm_kubernetes_cluster.aks]
}
