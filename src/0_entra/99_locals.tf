locals {
  product     = "${var.prefix}-${var.env_short}"
  product_ita = "${var.prefix}-${var.env_short}-${var.location_short}"
  project     = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}"

  argocd_application_owners = [
    "diego.lagosmorales@pagopa.it",
    "matteo.alongi@pagopa.it",
    "marco.mari@pagopa.it",
    "umberto.coppolabottazzi@pagopa.it",
    "fabio.felici@pagopa.it"
  ]

  argocd_hostname = "argocd.internal.devopslab.pagopa.it"

  kubernetes_cluster_name                = "dvopla-d-itn-dev-aks"
  kubernetes_cluster_resource_group_name = "dvopla-d-itn-dev-aks-rg"

  argocd_namespace            = "argocd"
  argocd_service_account_name = "argocd-server"
}
