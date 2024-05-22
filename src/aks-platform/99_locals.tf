locals {
  product = "${var.prefix}-${var.env_short}"
  product_ita = "${var.prefix}-${var.env_short}-${var.location_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}"

  # AKS
  aks_rg_name        = "${local.project}-aks-rg"
  aks_backup_rg_name = "${local.project}-aks-backup-rg"
  aks_cluster_name   = "${local.project}-aks"
  velero_rg_name     = "${local.project}-velero"

  # VNET
  vnet_core_resource_group_name = "${local.product}-vnet-rg"
  vnet_core_name                = "${local.product}-vnet"

  ingress_hostname_prefix = "argocd"
  internal_dns_zone_name  = "${var.dns_zone_internal_prefix}.${var.external_domain}"

  internal_dns_zone_resource_group_name = "${local.product_ita}-vnet-rg"

  # ACR DOCKER
  docker_rg_name       = "dvopla-d-docker-registry-rg"
  docker_registry_name = "dvopladitnacr"

  # monitor
  monitor_rg_name                                 = "${local.product_ita}-monitor-rg"
  monitor_log_analytics_workspace_name            = "${local.product_ita}-law"
  monitor_appinsights_name                        = "${local.product_ita}-appinsights"
  monitor_security_storage_name                   = replace("${local.product}-sec-monitor-st", "-", "")

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  argocd_internal_url = "argocd.internal.devopslab.pagopa.it"

}
