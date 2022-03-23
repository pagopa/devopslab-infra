module "helm-template-ingress" {
  source = "../../../azurerm/kubernetes_ingress"
  # source = "git::https://github.com/pagopa/azurerm.git//kubernetes_ingress?ref=k8s-ingress"

  depends_on = [
    module.nginx_ingress,
    null_resource.enable_pod_identity
  ]

  resource_group_name = format("%s-aks-rg", local.project)
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id

  keyvault           = data.azurerm_key_vault.kv

  name         = "ingress"
  namespace    = "helm-template"
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
