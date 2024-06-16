data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

resource "azurerm_private_dns_a_record" "itn_testit_ingress" {
  name                = local.ingress_hostname_prefix
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = local.internal_dns_zone_resource_group_name
  ttl                 = 3600
  records             = [var.ingress_load_balancer_ip]
}

#
# SUBNET
#
resource "azurerm_subnet" "user_testit_subnet" {
  name                 = "${local.project}-aks-testit-user"
  resource_group_name  = data.azurerm_resource_group.vnet_italy_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet_italy.name
  address_prefixes     = var.cidr_subnet_user_aks_testit

  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}
