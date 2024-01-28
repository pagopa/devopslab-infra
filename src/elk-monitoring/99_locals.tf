locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  app_insights_ips_west_europe = [
    "51.144.56.96/28",
    "51.144.56.112/28",
    "51.144.56.128/28",
    "51.144.56.144/28",
    "51.144.56.160/28",
    "51.144.56.176/28",
  ]

  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  vnet_name                = "dvopla-d-neu-dev01-aks-vnet"
  vnet_resource_group_name = "dvopla-d-neu-dev01-aks-vnet-rg"

  acr_name                = replace("${local.product}commonacr", "-", "")
  acr_resource_group_name = "${local.product}-container-registry-rg"

  aks_name                = "dvopla-d-neu-dev01-aks"
  aks_resource_group_name = "dvopla-d-neu-dev01-aks-rg"
  aks_subnet_name         = "dvopla-d-neu-dev01-aks-snet"

  ingress_hostname                      = "${var.location_short}${var.instance}.${var.domain}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  pagopa_apim_name = "${local.product}-apim"
  pagopa_apim_rg   = "${local.product}-api-rg"

  apim_hostname = "api.${var.apim_dns_zone_prefix}.${var.external_domain}"

  kibana_hostname          = "${var.instance}.kibana.internal.devopslab.pagopa.it"
  kibana_internal_hostname = "${var.instance}.kibana.internal.devopslab.pagopa.it"
  kibana_hostname_short    = "${var.instance}.kibana"
  kibana_external_domain   = "https://${local.kibana_hostname}/kibana"
  kibana_internal_domain   = "https://${local.kibana_hostname}/kibana"

  elk_namespace = "elastic-system"
}
