# 🔭 Monitor
data "azurerm_resource_group" "rg_monitor" {
  name  = format("%s-monitor-rg", local.project)
}

data "azurerm_application_insights" "application_insights" {
  name                = format("%s-appinsights", local.project)
  resource_group_name = data.azurerm_resource_group.rg_monitor.name
}
