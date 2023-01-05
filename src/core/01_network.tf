# Subnet to host the api config
module "private_endpoints_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.8.1"
  name                 = "${local.program}-private-endpoints-snet"
  address_prefixes     = var.cidr_subnet_private_endpoints
  virtual_network_name = data.azurerm_virtual_network.vnet.name

  resource_group_name = data.azurerm_resource_group.rg_vnet.name

  enforce_private_link_endpoint_network_policies = true
  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Storage",
  ]
}
