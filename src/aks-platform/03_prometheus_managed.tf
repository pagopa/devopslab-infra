# resource "azurerm_monitor_workspace" "prometheus_amw" {
#   name                = local.monitor_log_analytics_workspace_prometheus_name
#   location            = azurerm_resource_group.rg_aks.location
#   resource_group_name = azurerm_resource_group.rg_aks.name

#   tags = var.tags
# }

# resource "azurerm_monitor_data_collection_endpoint" "prometheus_dce" {
#   name                = "${local.project}-prometheus-dce"
#   location            = azurerm_resource_group.rg_aks.location
#   resource_group_name = azurerm_resource_group.rg_aks.name
#   kind                = "Linux"
# }

# resource "azurerm_monitor_data_collection_rule" "prometheus_dcr" {
#   name                        = "${local.project}-prometheus-dcr"
#   location                    = azurerm_resource_group.rg_aks.location
#   resource_group_name         = azurerm_resource_group.rg_aks.name
#   data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.prometheus_dce.id
#   kind                        = "Linux"

#   destinations {
#     monitor_account {
#       monitor_account_id = azurerm_monitor_workspace.prometheus_amw.id
#       name               = "monitoring_account_prometheus"
#     }
#   }

#   data_flow {
#     streams      = ["Microsoft-PrometheusMetrics"]
#     destinations = ["monitoring_account_prometheus"]
#   }

#   data_sources {
#     prometheus_forwarder {
#       streams = ["Microsoft-PrometheusMetrics"]
#       name    = "PrometheusDataSource"
#     }
#   }

#   description = "DCR for Azure Monitor Metrics Profile (Managed Prometheus)"
#   depends_on = [
#     azurerm_monitor_data_collection_endpoint.prometheus_dce,
#   ]
# }

# resource "azurerm_monitor_data_collection_rule_association" "dcra" {
#   name                    = "${local.project}-prometheus-dcra"
#   target_resource_id      = module.aks[0].id
#   data_collection_rule_id = azurerm_monitor_data_collection_rule.prometheus_dcr.id
#   description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
#   depends_on = [
#     azurerm_monitor_data_collection_rule.prometheus_dcr
#   ]
# }


