resource "helm_release" "kubecost" {
  name       = "costs-monitoring"
  repository = "https://kubecost.github.io/cost-analyzer"
  chart      = "cost-analyzer"
  namespace  = kubernetes_namespace.costs_monitoring.metadata[0].name

  set {
    name  = "kubecostToken"
    value = "ZmFiaW8uZmVsaWNpQHBhZ29wYS5pdA==xm343yadf98"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }
}
