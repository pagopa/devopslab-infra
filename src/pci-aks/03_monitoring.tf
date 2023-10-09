# resource "kubernetes_namespace" "monitoring" {
#   metadata {
#     name = "monitoring"
#   }
#   depends_on = [module.aks_pci]
# }

# module "aks_prometheus_install" {
#   source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_prometheus_install?ref=v7.10.1"
#   prometheus_namespace = kubernetes_namespace.monitoring.metadata[0].name
#   storage_class_name   = "default-zrs"
# }
