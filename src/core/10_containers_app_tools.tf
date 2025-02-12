resource "azurerm_resource_group" "tools_cae_rg" {
  name     = var.container_app_tools_cae_env_rg
  location = var.location_ita

  tags = var.tags
}

resource "azurerm_subnet" "tools_cae_snet" {
  name                 = "${local.project_ita}-tool-cae-snet"
  resource_group_name  = module.vnet_italy.resource_group_name
  virtual_network_name = module.vnet_italy.name
  address_prefixes     = var.cidr_subnet_tools_cae
}

module "container_app_environment" {
  source = "./.terraform/modules/__v3__/container_app_environment_v2"

  resource_group_name        = azurerm_resource_group.tools_cae_rg.name
  location                   = azurerm_resource_group.tools_cae_rg.location
  name                       = "${local.project_ita}-tool-cae"
  internal_load_balancer     = false
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace_ita.id

  tags = var.tags
}
