## VPN subnet
module "vpn_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                                      = "GatewaySubnet"
  address_prefixes                          = var.cidr_subnet_vpn
  virtual_network_name                      = data.azurerm_virtual_network.vnet_ita_core.name
  resource_group_name                       = data.azurerm_resource_group.rg_vnet_ita.name
  service_endpoints                         = []
}

data "azuread_application" "vpn_app" {
  display_name = "dvopla-d-app-vpn"
}

module "vpn" {
  # source = "./.terraform/modules/__v4__/vpn_gateway"
    source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//vpn_gateway?ref=PAYMCLOUD-399-v-4-vpn-update"

  name                  = "${local.project}-vpn"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg_vnet_ita.name
  sku                   = var.vpn_sku
  pip_sku               = var.vpn_pip_sku
  subnet_id             = module.vpn_snet.id
  pip_allocation_method = "Static"

  vpn_client_configuration = [
    {
      address_space         = ["172.16.1.0/24"],
      vpn_client_protocols  = ["OpenVPN"],
      aad_audience          = data.azuread_application.vpn_app.client_id
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

# # Dns Forwarder module
#
# module "subnet_dns_forwarder_lb" {
#   source = "./.terraform/modules/__v4__/subnet"
#   count  = var.dns_forwarder_is_enabled ? 1 : 0
#
#   name                 = "${local.project}-dns-forwarder-lb"
#   address_prefixes     = var.cidr_subnet_dnsforwarder_lb
#   virtual_network_name = local.vnet_ita_name
#   resource_group_name  = local.vnet_ita_resource_group_name
# }
#
# module "subnet_dns_forwarder_vmss" {
#   source = "./.terraform/modules/__v4__/subnet"
#   count  = var.dns_forwarder_is_enabled ? 1 : 0
#
#   name                 = "${local.project}-dns-forwarder-vmss"
#   address_prefixes     = var.cidr_subnet_dnsforwarder_vmss
#   virtual_network_name = local.vnet_ita_name
#   resource_group_name  = local.vnet_ita_resource_group_name
# }
#
# module "dns_forwarder_lb_vmss" {
#   source = "./.terraform/modules/__v4__/dns_forwarder_lb_vmss"
#   count  = var.dns_forwarder_is_enabled ? 1 : 0
#
#   name                 = local.project
#   virtual_network_name = local.vnet_ita_name
#   resource_group_name  = local.vnet_ita_resource_group_name
#
#   subnet_lb_id      = module.subnet_dns_forwarder_lb[0].id
#   static_address_lb = cidrhost(var.cidr_subnet_dnsforwarder_lb[0], 4)
#   subnet_vmss_id    = module.subnet_dns_forwarder_vmss[0].id
#
#   location          = var.location
#   subscription_id   = data.azurerm_subscription.current.subscription_id
#   key_vault_id      = data.azurerm_key_vault.kv.id
#   tenant_id         = data.azurerm_client_config.current.id
#   tags              = var.tags
#   source_image_name = "dvopla-d-itn-dns-forwarder-ubuntu2204-image-${var.dns_forwarder_vmss_image_version}"
# }
