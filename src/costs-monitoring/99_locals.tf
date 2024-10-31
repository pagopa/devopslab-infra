locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}"

  # AKS
  aks_rg_name      = "${local.project}-aks-rg"
  aks_cluster_name = "${local.project}-aks"

  costs_monitoring_namespace = "costs-monitoring"
}
