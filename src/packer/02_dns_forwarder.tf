module "dns_forwarder_image" {
  # source              = "./.terraform/modules/__v3__/dns_forwarder_vm_image"
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder_vm_image?ref=PAYMCLOUD-247-dns-forwarder-aggiornare-limmagine-allultima-versione-disponibile"

  resource_group_name = data.azurerm_resource_group.rg_vnet_ita.name
  location            = var.location
  image_name          = "${local.project}-dns-forwarder-ubuntu2204-image"
  image_version       = var.dns_forwarder_image_version
  subscription_id     = data.azurerm_subscription.current.subscription_id
  prefix              = local.project

}
