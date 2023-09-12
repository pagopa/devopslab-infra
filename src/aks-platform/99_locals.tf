locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  # AKS
  aks_rg_name      = "${local.project}-aks-rg"
  aks_backup_rg_name = "${local.project}-aks-backup-rg"
  aks_cluster_name = "${local.project}-aks"
  velero_rg_name   = "${local.project}-velero"

  # VNET
  vnet_core_resource_group_name = "${local.product}-vnet-rg"
  vnet_core_name                = "${local.product}-vnet"

  # ACR DOCKER
  docker_rg_name       = "dvopla-d-dockerreg-rg"
  docker_registry_name = "dvopladneuacr"

  # monitor
  monitor_rg_name                                 = "${local.product}-monitor-rg"
  monitor_log_analytics_workspace_name            = "${local.product}-law"
  monitor_log_analytics_workspace_prometheus_name = "${local.product}-prometheus-law"
  monitor_appinsights_name                        = "${local.product}-appinsights"
  monitor_security_storage_name                   = replace("${local.product}-sec-monitor-st", "-", "")

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"
}
