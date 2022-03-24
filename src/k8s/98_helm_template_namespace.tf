resource "kubernetes_namespace" "helm_template" {
  metadata {
    name = "helm-template"
  }
}

module "helm-template-ingress" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_ingress?ref=v2.7.0"

  depends_on = [module.nginx_ingress]

  resource_group_name = format("%s-aks-rg", local.project)
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id

  key_vault = data.azurerm_key_vault.kv

  name         = "ingress"
  namespace    = kubernetes_namespace.helm_template.metadata[0].name
  cluster_name = data.azurerm_kubernetes_cluster.aks_cluster.name

  host  = "helm-template.ingress.devopslab.pagopa.it"
  rules = [
    {
      path         = "/(.*)"
      service_name = "templatemicroserviziok8s-microservice-chart"
      service_port = 80
    }
  ]
}
