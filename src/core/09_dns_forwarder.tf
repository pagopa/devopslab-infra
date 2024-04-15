
# Dns Forwarder module

module "dns_forwarder_lb_vmss" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder_lb_vmss?ref=v7.77.0"
  count  = var.dns_forwarder_is_enabled ? 1 : 0

  name                 = local.project
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_resource_group_name
  location             = var.location
  subscription_id      = data.azurerm_subscription.current.subscription_id
  source_image_name    = local.dns_forwarder_vm_image_name
  tenant_id            = data.azurerm_client_config.current.tenant_id
  key_vault_id         = data.azurerm_key_vault.kv.id
  tags                 = var.tags
}
