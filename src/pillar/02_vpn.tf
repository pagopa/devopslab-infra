## VPN subnet
module "vpn_snet" {
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v3.6.7"
  name                                           = "GatewaySubnet"
  address_prefixes                               = var.cidr_subnet_vpn
  virtual_network_name                           = module.vnet.name
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  service_endpoints                              = []
  private_endpoint_network_policies_enabled = true
}

data "azuread_application" "vpn_app" {
  display_name = "${local.project}-app-vpn"
}

module "vpn" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//vpn_gateway?ref=v3.6.7"

  name                = "${local.project}-vpn"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  sku                 = var.vpn_sku
  pip_sku             = var.vpn_pip_sku
  subnet_id           = module.vpn_snet.id

  vpn_client_configuration = [
    {
      address_space         = ["172.16.1.0/24"],
      vpn_client_protocols  = ["OpenVPN"],
      aad_audience          = data.azuread_application.vpn_app.application_id
      aad_issuer            = "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/"
      aad_tenant            = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
      radius_server_address = null
      radius_server_secret  = null
      revoked_certificate   = []
      root_certificate      = []
    }
  ]

  tags = var.tags
}

#
# DNS Forwarder
#
resource "azurerm_resource_group" "dns_forwarder" {

  count = var.dns_forwarder_enabled ? 1 : 0

  name     = "${local.project}-dns-forwarder-rg"
  location = var.location

  tags = var.tags
}

module "dns_forwarder_snet" {
  count = var.dns_forwarder_enabled ? 1 : 0

  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v3.6.7"
  name                                           = "${local.project}-dnsforwarder-snet"
  address_prefixes                               = var.cidr_subnet_dnsforwarder
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  private_endpoint_network_policies_enabled = true

  delegation = {
    name = "delegation"
    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

module "dns_forwarder" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder?ref=v3.6.7"

  name                = "${local.project}-dns-forwarder"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  subnet_id           = module.dns_forwarder_snet[0].id

  tags = var.tags
}
