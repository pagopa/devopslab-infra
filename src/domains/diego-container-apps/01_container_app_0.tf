resource "azurerm_resource_group" "container_app_diego" {
  name     = local.container_app_diego_environment_resource_group
  location = var.location
  tags     = var.tags
}

resource "null_resource" "update_az_cli" {
  triggers = {
    env_name                                   = local.container_app_diego_environment_name
    rg                                         = azurerm_resource_group.container_app_diego.name
    subnet_id                                  = module.container_apps_snet.id
    log_analytics_id                           = data.azurerm_log_analytics_workspace.log_analytics.workspace_id
    log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  }

  provisioner "local-exec" {
    command = <<EOT
      az extension add --name containerapp --upgrade
      az provider register --namespace Microsoft.App
      az provider register --namespace Microsoft.OperationalInsights
    EOT
  }

  depends_on = [
    module.container_apps_snet,
    azurerm_resource_group.container_app_diego
  ]
}
