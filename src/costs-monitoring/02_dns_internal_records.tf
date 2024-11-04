resource "azurerm_private_dns_a_record" "cost_monitoring_internal_record" {
  name                = "costs-monitoring.itn"
  resource_group_name = data.azurerm_private_dns_zone.internal_dbs_zone.resource_group_name
  ttl                 = 3600
  zone_name           = data.azurerm_private_dns_zone.internal_dbs_zone.name
  records             = ["10.3.10.250"]
}
