resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  depends_on = [module.aks]
}

module "aks_prometheus_install" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_prometheus_install?ref=v8.78.0"
  prometheus_namespace = kubernetes_namespace.monitoring.metadata[0].name
  storage_class_name   = "default-zrs"
  prometheus_helm = {
    replicas                  = 1
    server_storage_size       = "128Gi"
    alertmanager_storage_size = "32Gi"
  }
  prometheus_crds_enabled = true

  depends_on = [module.aks_storage_class]
}
