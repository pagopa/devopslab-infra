resource "kubernetes_namespace" "helm_template" {
  metadata {
    name = "helm-template"
  }
}

module "helm_template_ingress" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_ingress?ref=v2.12.5"

  resource_group_name = "${local.project}-aks-rg"
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id

  key_vault = data.azurerm_key_vault.kv

  name         = "ingress"
  namespace    = kubernetes_namespace.helm_template.metadata[0].name
  cluster_name = data.azurerm_kubernetes_cluster.aks_cluster.name

  host = "helm-template.ingress.devopslab.pagopa.it"
  rules = [
    {
      path         = "/(.*)"
      service_name = "templatemicroserviziok8s-microservice-chart"
      service_port = 80
    }
  ]
}

module "helm_template_ingress_pod_identity" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity?ref=v2.10.0"

  resource_group_name = "${local.project}-aks-rg"

  location      = var.location
  identity_name = "${kubernetes_namespace.helm_template.metadata[0].name}-pod-identity"
  key_vault     = data.azurerm_key_vault.kv
  tenant_id     = data.azurerm_subscription.current.tenant_id
  cluster_name  = data.azurerm_kubernetes_cluster.aks_cluster.name
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
