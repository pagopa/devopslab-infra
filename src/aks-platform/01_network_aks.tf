# k8s cluster subnet
module "snet_aks" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.69.1"

  name = "${local.project}-aks-snet"

  resource_group_name  = data.azurerm_resource_group.vnet_italy_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet_italy.name

  address_prefixes                          = var.cidr_subnet_aks
  private_endpoint_network_policies_enabled = var.aks_private_cluster_enabled

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]
}
