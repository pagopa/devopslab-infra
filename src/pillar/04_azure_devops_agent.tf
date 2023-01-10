resource "azurerm_resource_group" "azdo_rg" {
  count    = var.enable_azdoa ? 1 : 0
  name     = local.azuredevops_rg_name
  location = var.location

  tags = var.tags
}

module "azdoa_snet" {
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v3.6.7"
  count                                          = var.enable_azdoa ? 1 : 0
  name                                           = local.azuredevops_subnet_name
  address_prefixes                               = var.cidr_subnet_azdoa
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  private_endpoint_network_policies_enabled = true
}

module "azdoa_vmss_li" {
  source   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent?ref=v3.6.7"
  count               = var.enable_azdoa ? 1 : 0
  name                = local.azuredevops_agent_vm_name
  resource_group_name = azurerm_resource_group.azdo_rg[0].name
  subnet_id           = module.azdoa_snet[0].id
  subscription        = data.azurerm_subscription.current.display_name

  tags = var.tags
}
