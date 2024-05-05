## VPN subnet
module "vpn_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v8.5.0"
  name                                      = "GatewaySubnet"
  address_prefixes                          = var.cidr_subnet_vpn
  virtual_network_name                      = module.vnet_italy.name
  resource_group_name                       = azurerm_resource_group.rg_ita_vnet.name
  service_endpoints                         = []
  private_endpoint_network_policies_enabled = true
}

data "azuread_application" "vpn_app" {
  display_name = "${local.project}-app-vpn"
}

module "vpn" {
  count  = var.vpn_enabled ? 1 : 0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//vpn_gateway?ref=v8.5.0"

  name                  = "${local.project_ita}-vpn"
  location              = var.location_ita
  resource_group_name   = azurerm_resource_group.rg_ita_vnet.name
  sku                   = var.vpn_sku
  pip_sku               = var.vpn_pip_sku
  pip_allocation_method = "Static"
  subnet_id             = module.vpn_snet.id

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

# Dns Forwarder module

module "subnet_dns_forwarder_lb" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v8.5.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                 = "${local.project_ita}-dns-forwarder-lb"
  address_prefixes     = var.cidr_subnet_dnsforwarder_lb
  virtual_network_name = local.vnet_ita_name
  resource_group_name  = local.vnet_ita_resource_group_name
}

module "subnet_dns_forwarder_vmss" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v8.5.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                 = "${local.project_ita}-dns-forwarder-vmss"
  address_prefixes     = var.cidr_subnet_dnsforwarder_vmss
  virtual_network_name = local.vnet_ita_name
  resource_group_name  = local.vnet_ita_resource_group_name
}

module "dns_forwarder_lb_vmss" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder_lb_vmss?ref=dns-forwarder-lb-fix"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                 = local.project
  virtual_network_name = local.vnet_ita_name
  resource_group_name  = local.vnet_ita_resource_group_name

  subnet_lb_id      = module.subnet_dns_forwarder_lb[0].id
  static_address_lb = cidrhost(var.cidr_subnet_dnsforwarder_lb[0], 4)
  subnet_vmss_id    = module.subnet_dns_forwarder_vmss[0].id

  location          = var.location_ita
  subscription_id   = data.azurerm_subscription.current.subscription_id
  source_image_name = var.dns_forwarder_vmss_image_name
  key_vault_id      = data.azurerm_key_vault.kv.id
  tags              = var.tags
}
