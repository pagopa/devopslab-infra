#
# Subnet Vmss
#

module "dns_forwarder_vms_snet" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.38.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                 = "${local.project}-dns-forwarder-vm-snet"
  address_prefixes     = [var.cidr_subnet_dns_forwarder_vms]
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
  subnet_id           = module.dns_forwarder_vms_snet[0].id
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
  address_prefixes     = [var.cidr_subnet_dns_forwarder_lb]
  resource_group_name  = local.vnet_resource_group_name
  virtual_network_name = local.vnet_name
}

#
# Load Balancer
#

module "dns_forwarder_lb" {
  source  = "Azure/loadbalancer/azurerm"
  version = "4.4.0"

  resource_group_name = local.vnet_resource_group_name
  prefix              = "${local.project}-dns-forwarder-lb"
  type                = "private"
  lb_sku              = "Standard"

  frontend_subnet_id                     = module.dns_forwarder_lb_snet[0].id
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = local.dns_forwarder_lb_private_ip

  lb_port = {
    dns_tcp = ["53", "Tcp", "53"]
    dns_udp = ["53", "Udp", "53"]
  }

  lb_probe = {
    dns = ["Tcp", "53", ""]
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool_address" "dns_forwarder_address_vmss" {
  count = length(local.dns_forwarder_vm_avaiable_ips)

  name                    = "${local.project}-dns-forwarder-address-vmss-${count.index}"
  backend_address_pool_id = module.dns_forwarder_lb.azurerm_lb_backend_address_pool_id
  virtual_network_id      = module.vnet.id
  ip_address              = local.dns_forwarder_vm_avaiable_ips[count.index]
}

resource "azurerm_lb_backend_address_pool_address" "dns_forwarder_address_container_instance" {
  count = length(local.dns_forwarder_container_instance)

  name                    = "${local.project}-dns-forwarder-address-ci-${count.index}"
  backend_address_pool_id = module.dns_forwarder_lb.azurerm_lb_backend_address_pool_id
  virtual_network_id      = module.vnet.id
  ip_address              = local.dns_forwarder_container_instance[count.index]
}
