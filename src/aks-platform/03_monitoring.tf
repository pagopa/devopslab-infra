resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  depends_on = [module.aks]
}

module "aks_prometheus_install" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_prometheus_install?ref=v8.21.0"
  prometheus_namespace = kubernetes_namespace.monitoring.metadata[0].name
  storage_class_name   = "default-zrs"

  depends_on = [module.aks_storage_class]
}
