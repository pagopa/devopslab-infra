data "azurerm_resource_group" "rg_common" {
  name = "${var.prefix}-${var.env_short}-vnet-rg"
}

data "azurerm_key_vault" "key_vault_common" {
  name                = "${var.prefix}-${var.env_short}-${var.location_short}-kv"
  resource_group_name = "${var.prefix}-${var.env_short}-sec-rg"
}

data "azurerm_virtual_network" "vnet_common" {
  name                = var.networking.vnet_common_name
  resource_group_name = data.azurerm_resource_group.rg_common.name
}

data "azurerm_log_analytics_workspace" "law_common" {
  name                = var.law_name
  resource_group_name = "${var.prefix}-${var.env_short}-monitor-rg"
}
