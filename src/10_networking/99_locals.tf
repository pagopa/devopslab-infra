locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}"

  # VNET
  vnet_name                = "${local.project}-vnet"
  vnet_resource_group_name = "${local.project}-vnet-rg"

  vnet_legacy_name                = "${local.product}-vnet"
  vnet_legacy_resource_group_name = "${local.product}-vnet-rg"

  ### KV
  kv_name                = "${local.project}-core-kv"
  kv_resource_group_name = "${local.project}-sec-rg"

  appgateway_public_ip_name      = "${local.project}-gw-pip"
  appgateway_beta_public_ip_name = "${local.project}-gw-beta-pip"

  prod_dns_zone_public_name = "${var.dns_zone_prefix}.${var.external_domain}"
  dns_zone_private_name     = "${var.dns_zone_internal_prefix}.${var.external_domain}"
}
