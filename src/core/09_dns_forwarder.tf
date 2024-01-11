#
# Subnet Vmss
#

module "dns_forwarder_vm_snet" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.38.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                 = "${local.project}-dns-forwarder-vm-snet"
  address_prefixes     = var.cidr_subnet_dns_forwarder_vms
  resource_group_name  = local.vnet_resource_group_name
  virtual_network_name = local.vnet_name
}

#
# Scale Set
#

module "dns_forwarder_vmss" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder_scale_set_vm?ref=v7.38.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                = "${local.project}-dns-forwarder-vmss"
  resource_group_name = local.vnet_resource_group_name
  subnet_id           = module.dns_forwarder_vm_snet[0].id
  subscription_name   = data.azurerm_subscription.current.display_name
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location
  source_image_name   = local.dns_forwarder_vm_image_name

  tags = var.tags
}

#
# Subnet Load Balancer
#

module "dns_forwarder_lb_snet" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.38.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                 = "${local.project}-dns-forwarder-lb-snet"
  address_prefixes     = var.cidr_subnet_dns_forwarder_lb
  resource_group_name  = local.vnet_resource_group_name
  virtual_network_name = local.vnet_name
}

#
# Load Balancer
#

module "dns_forwarder_lb" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//load_balancer?ref=v7.38.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                = "${local.project}-dns-forwarder-internal"
  resource_group_name = local.vnet_resource_group_name
  location            = var.location
  lb_sku              = "Standard"
  type                = "private"

  frontend_name               = "${local.project}-ip-private"
  frontend_private_ip_address = local.dns_forwarder_lb_private_ip
  frontend_subnet_id          = module.dns_forwarder_lb_snet[0].id

  lb_backend_pools = [
    {
      name = "${var.prefix}-default-backend"
      ips = [
        for i in concat(var.dns_forwarder_lb_backend_pool_vmss_ips, var.dns_forwarder_lb_backend_pool_container_instance_ips) : {
          ip      = i
          vnet_id = data.azurerm_virtual_network.vnet.id
        }
      ]
    }
  ]

  lb_port = {
    "${var.prefix}-dns-tcp" = {
      frontend_port     = "53"
      protocol          = "Tcp"
      backend_port      = "53"
      backend_pool_name = "${var.prefix}-default-backend"
      probe_name        = "${var.prefix}-dns"
    }
    "${var.prefix}-dns-udp" = {
      frontend_port     = "53"
      protocol          = "Udp"
      backend_port      = "53"
      backend_pool_name = "${var.prefix}-default-backend"
      probe_name        = "${var.prefix}-dns"
    }
  }

  lb_probe = {
    "${var.prefix}-dns" = {
      protocol     = "Tcp"
      port         = "53"
      request_path = ""
    }
  }
  tags = var.tags
}
