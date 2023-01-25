resource "azurerm_resource_group" "container_app_diego" {
  name     = local.container_app_diego_environment_resource_group
  location = var.location
  tags     = var.tags
}

# Subnet to host the api config
module "container_apps_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v4.1.0"
  name                 = "${local.project}-container-apps-snet"
  address_prefixes     = var.cidr_subnet_container_apps
  virtual_network_name = data.azurerm_virtual_network.vnet_core.name

  resource_group_name = data.azurerm_resource_group.rg_vnet_core.name

  private_endpoint_network_policies_enabled = true
}

resource "null_resource" "update_az_cli" {

  triggers = {
    env_name = local.container_app_diego_environment_name
    rg = azurerm_resource_group.container_app_diego.name
    subnet_id = module.container_apps_snet.id
    log_analytics_id = data.azurerm_log_analytics_workspace.log_analytics.workspace_id
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

resource "null_resource" "container_app_create_env" {

  triggers = {
    env_name = local.container_app_diego_environment_name
    rg = azurerm_resource_group.container_app_diego.name
    subnet_id = module.container_apps_snet.id
    log_analytics_id = data.azurerm_log_analytics_workspace.log_analytics.workspace_id
    log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  }

  provisioner "local-exec" {
    command = <<EOT
      az containerapp env create \
          -n ${local.container_app_diego_environment_name} \
          -g ${azurerm_resource_group.container_app_diego.name} \
          --location ${var.location} \
          --infrastructure-subnet-resource-id ${module.container_apps_snet.id} \
          --internal-only false \
          --logs-destination log-analytics \
          --logs-workspace-id "${data.azurerm_log_analytics_workspace.log_analytics.workspace_id}" \
          --logs-workspace-key "${data.azurerm_log_analytics_workspace.log_analytics.primary_shared_key}"
    EOT
  }

  depends_on = [
    module.container_apps_snet,
    azurerm_resource_group.container_app_diego
  ]
}
