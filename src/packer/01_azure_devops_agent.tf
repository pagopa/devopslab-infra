data "azurerm_resource_group" "resource_group" {
  name = local.azdo_resource_group_name
}

module "azdoa_custom_image" {
  # source = "./.terraform/modules/__v3__/azure_devops_agent_custom_image"
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent_custom_image?ref=PAYMCLOUD-246-azdo-aggiornare-limmagine-di-azdo-in-modo-che-abbiamo-kubectl-alla-versione-1-31"

  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = var.location
  image_name          = "azdo-agent-ubuntu2204-image"
  image_version       = var.azdo_image_version
  subscription_id     = data.azurerm_subscription.current.subscription_id
  prefix              = "devopla"

}
