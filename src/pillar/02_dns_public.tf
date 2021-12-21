#
# DNS principal/prod
#
resource "azurerm_dns_zone" "public" {
  name                = local.prod_dns_zone_public_name
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

# Prod ONLY record to LAB public DNS delegation
resource "azurerm_dns_ns_record" "lab_it_ns" {
  name                = "lab"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  records = [
    "ns1-03.azure-dns.com.",
    "ns2-03.azure-dns.net.",
    "ns3-03.azure-dns.org.",
    "ns4-03.azure-dns.info."
  ]
  ttl  = var.dns_default_ttl_sec
  tags = var.tags
}

resource "azurerm_dns_cname_record" "public_healthy" {
  name                = "healthy"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = 300
  record              = "google.com"
}

#
# LAB DNS ZONE
#
resource "azurerm_dns_zone" "lab" {
  name                = local.lab_dns_zone_public_name
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_dns_cname_record" "lab_healthy" {
  name                = "healthy"
  zone_name           = azurerm_dns_zone.lab.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = 300
  record              = "google.com"
}
