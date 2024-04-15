resource "azurerm_resource_group" "tools_cae_rg" {
  name     = var.container_app_tools_cae_env_rg
  location = var.location

  tags = var.tags
}

resource "azurerm_subnet" "tools_cae_snet" {
  name                 = "${local.project_neu}-tool-cae-snet"
  resource_group_name  = module.vnet.resource_group_name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_tools_cae
}

module "container_app_environment" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment_v2?ref=v7.77.0"

  resource_group_name        = azurerm_resource_group.tools_cae_rg.name
  location                   = azurerm_resource_group.tools_cae_rg.location
  name                       = "${local.project_neu}-tool-cae"
  internal_load_balancer     = false
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tags = var.tags
}

