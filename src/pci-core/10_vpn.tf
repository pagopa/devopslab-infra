# ## VPN subnet
module "vpn_snet" {
  source                                        = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.5.2"
  name                                          = "GatewaySubnet"
  address_prefixes                              = var.cidr_vpn_subnet
  resource_group_name                           = azurerm_resource_group.rg_vnet.name
  virtual_network_name                          = module.vnet_hub.name
  service_endpoints                             = []
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
}

data "azuread_application" "vpn_app" {
  display_name = format("%s-app-vpn", local.product)
}

module "vpn" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//vpn_gateway?ref=v5.5.2"



  name                = format("%s-vpn", local.project)
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
      aad_issuer            = format("https://sts.windows.net/%s/", data.azurerm_subscription.current.tenant_id)
      aad_tenant            = format("https://login.microsoftonline.com/%s", data.azurerm_subscription.current.tenant_id)
      radius_server_address = null
      radius_server_secret  = null
      revoked_certificate   = []
      root_certificate      = []
    }
  ]

  tags = var.tags
}

## DNS Forwarder
module "dns_forwarder_snet" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.5.2"

  name                                          = format("%s-dns-forwarder-snet", local.project)
  address_prefixes                              = var.cidr_subnet_dns_forwarder
  resource_group_name                           = azurerm_resource_group.rg_vnet.name
  virtual_network_name                          = module.vnet_hub.name
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true

  delegation = {
    name = "delegation"
    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

module "dns_forwarder" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder?ref=v6.15.2"

  name                = format("%s-dns-forwarder", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  subnet_id           = module.dns_forwarder_snet.id

  tags = var.tags
}