locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  #DR
  project_dr = "${var.prefix}-${var.env_short}-${var.location_short_dr}-${var.domain}"

  app_insights_ips_west_europe = [
  ]

  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  vnet_resource_group_name = "${local.product}-vnet-rg"

}
