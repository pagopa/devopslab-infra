# Subnet to host app function
module "funcs_diego_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=version-unlocked"
  name                                           = "${local.project}-funcs-snet"
  address_prefixes                               = var.cidr_subnet_funcs_diego_domain
  resource_group_name                            = data.azurerm_resource_group.rg_vnet_core.name
  virtual_network_name                           = data.azurerm_virtual_network.vnet_core.name
  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Storage",
  ]

  delegation = {
    name = "default"
    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_resource_group" "funcs_diego_rg" {
  name     = "${local.project}-funcs-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_app_service_plan" "funcs_diego" {

  count = var.app_service_plan_enabled ? 1 : 0

  name                = "${local.project}-funcs-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.funcs_diego_rg.name
  kind                = "Linux"

  sku {
    tier = "PremiumV3"
    size = "P1v3"
    # capacity is only for isolated envs
  }

  maximum_elastic_worker_count = 1
  reserved                     = true
  per_site_scaling             = false

  tags = var.tags
}


