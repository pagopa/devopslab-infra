resource "kubernetes_namespace" "helm_template" {
  metadata {
    name = "helm-template"
  }
}

module "helm-template-ingress" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_ingress?ref=v2.7.0"

  depends_on = [module.nginx_ingress]

  resource_group_name = "${local.project}-aks-rg"
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
<<<<<<< HEAD
      service_name = "templatemicroserviziok8s-microservice-chart"
>>>>>>> e2f12fb (Use kubernetes_ingress module for helm_template namespace)
=======
      service_name = "template-microservice-chart"
>>>>>>> d8069f1 (Move reloader and create pod identity inside helm_template namespace)
      service_port = 80
    }
  ]
}
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d8069f1 (Move reloader and create pod identity inside helm_template namespace)

module "ingress_pod_identity" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity?ref=v2.6.0"

<<<<<<< HEAD
  resource_group_name = "${local.project}-aks-rg"
=======
  resource_group_name = format("%s-aks-rg", local.project)
>>>>>>> d8069f1 (Move reloader and create pod identity inside helm_template namespace)
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
<<<<<<< HEAD
  version    = "v0.0.109"
=======
  version    = "0.0.109"
>>>>>>> d8069f1 (Move reloader and create pod identity inside helm_template namespace)
  namespace  = kubernetes_namespace.helm_template.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
<<<<<<< HEAD
=======
>>>>>>> e2f12fb (Use kubernetes_ingress module for helm_template namespace)
=======
>>>>>>> d8069f1 (Move reloader and create pod identity inside helm_template namespace)
