resource "kubernetes_namespace" "helm_template" {
  metadata {
    name = "helm-template"
  }
}

module "helm-template-ingress" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_ingress?ref=v2.7.0"

  depends_on = [module.nginx_ingress]

<<<<<<< HEAD
  resource_group_name = "${local.project}-aks-rg"
=======
  resource_group_name = format("%s-aks-rg", local.project)
>>>>>>> e2f12fb (Use kubernetes_ingress module for helm_template namespace)
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id

  key_vault = data.azurerm_key_vault.kv

  name         = "ingress"
  namespace    = kubernetes_namespace.helm_template.metadata[0].name
  cluster_name = data.azurerm_kubernetes_cluster.aks_cluster.name

<<<<<<< HEAD
  host = "helm-template.ingress.devopslab.pagopa.it"
  rules = [
    {
      path         = "/(.*)"
      service_name = "template-microservice-chart"
=======
  host  = "helm-template.ingress.devopslab.pagopa.it"
  rules = [
    {
      path         = "/(.*)"
      service_name = "templatemicroserviziok8s-microservice-chart"
>>>>>>> e2f12fb (Use kubernetes_ingress module for helm_template namespace)
      service_port = 80
    }
  ]
}
<<<<<<< HEAD

module "ingress_pod_identity" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity?ref=v2.6.0"

  resource_group_name = "${local.project}-aks-rg"
  location            = var.location
  identity_name       = "${kubernetes_namespace.helm_template.metadata[0].name}-pod-identity"
  key_vault           = data.azurerm_key_vault.kv
  tenant_id           = data.azurerm_subscription.current.tenant_id
  cluster_name        = data.azurerm_kubernetes_cluster.aks_cluster.name
  namespace           = kubernetes_namespace.helm_template.metadata[0].name

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
=======
>>>>>>> e2f12fb (Use kubernetes_ingress module for helm_template namespace)
