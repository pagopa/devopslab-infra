resource "azurerm_resource_group" "azdo_rg" {
  count    = var.enable_azdoa ? 1 : 0
  name     = local.azuredevops_rg_name
  location = var.location

  tags = var.tags
}

module "azdoa_snet" {
  source                                    = "./.terraform/modules/__v3__/subnet"
  count                                     = var.enable_azdoa ? 1 : 0
  name                                      = local.azuredevops_subnet_name
  address_prefixes                          = var.cidr_subnet_azdoa
  resource_group_name                       = local.vnet_ita_resource_group_name
  virtual_network_name                      = local.vnet_ita_name
  private_endpoint_network_policies_enabled = true
}


module "azdoa_vmss_linux" {
  source              = "./.terraform/modules/__v3__/azure_devops_agent"
  count               = var.enable_azdoa ? 1 : 0
  name                = local.azuredevops_agent_vm_name
  resource_group_name = azurerm_resource_group.azdo_rg[0].name
  subnet_id           = module.azdoa_snet[0].id
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location_ita
  source_image_name   = "azdo-agent-ubuntu2204-image-${var.azdoa_image_version}"

  tags = var.tags
}
