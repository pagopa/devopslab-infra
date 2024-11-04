resource "helm_release" "kubecost" {
  name       = "costs-monitoring"
  repository = "https://kubecost.github.io/cost-analyzer"
  chart      = "cost-analyzer"
  namespace  = kubernetes_namespace.costs_monitoring.metadata[0].name

  set {
    name  = "kubecostToken"
    value = data.azurerm_key_vault_secret.kubecost-token.value
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set_list {
    name  = "ingress.hosts"
    value = ["costs-monitoring.itn.internal.devopslab.pagopa.it"]
  }

  set {
    name  = "ingress.className"
    value = "nginx"
  }
}
