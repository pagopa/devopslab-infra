#
# DNS principal/prod
#
resource "azurerm_dns_zone" "public" {
  name                = local.prod_dns_zone_public_name
  resource_group_name = local.vnet_ita_resource_group_name

  tags = var.tags
}

resource "azurerm_dns_cname_record" "public_healthy" {
  name                = "healthy"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = local.vnet_ita_resource_group_name
  ttl                 = 300
  record              = "google.com"

  tags = var.tags
}

#
# 🅰️ DNS A records
#

# application gateway records
# api.*.userregistry.pagopa.it
resource "azurerm_dns_a_record" "api_devopslab_pagopa_it" {
  name                = "api"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = local.vnet_ita_resource_group_name
  ttl                 = var.dns_default_ttl_sec
  records             = [azurerm_public_ip.appgateway_public_ip.ip_address]

  tags = var.tags
}
