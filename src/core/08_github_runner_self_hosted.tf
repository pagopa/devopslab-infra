resource "azurerm_resource_group" "github_runner_rg" {
  name     = local.container_app_github_runner_env_rg
  location = var.location

  tags = var.tags
}

resource "azurerm_subnet" "github_runner_snet" {
  name                 = "${local.project}-github-runner-snet"
  resource_group_name  = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.cidr_subnet_github_runner_self_hosted
}

resource "null_resource" "update_az_cli" {

  triggers = {
    env_name                                   = local.container_app_github_runner_env_name
    rg_name                                    = azurerm_resource_group.github_runner_rg.name
    subnet_id                                  = azurerm_subnet.github_runner_snet.id
    log_analytics_id                           = data.azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
    log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
  }

  provisioner "local-exec" {
    command = <<EOT
      az extension add --name containerapp --upgrade
      az provider register --namespace Microsoft.App
      az provider register --namespace Microsoft.OperationalInsights
    EOT
  }

  depends_on = [
    azurerm_subnet.github_runner_snet,
    azurerm_resource_group.github_runner_rg,
  ]
}

resource "null_resource" "container_app_create_env_github_runner" {

  triggers = {
    env_name                                   = local.container_app_github_runner_env_name
    rg_name                                    = azurerm_resource_group.github_runner_rg.name
    subnet_id                                  = azurerm_subnet.github_runner_snet.id
    log_analytics_id                           = data.azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
    log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
  }

  provisioner "local-exec" {
    command = <<EOT
      az containerapp env create \
          -n ${local.container_app_github_runner_env_name} \
          -g ${azurerm_resource_group.github_runner_rg.name} \
          --location ${var.location} \
          --infrastructure-subnet-resource-id ${azurerm_subnet.github_runner_snet.id} \
          --internal-only true \
          --logs-destination log-analytics \
          --logs-workspace-id "${data.azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id}" \
          --logs-workspace-key "${data.azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key}"
    EOT
  }

  depends_on = [
    azurerm_subnet.github_runner_snet,
    azurerm_resource_group.github_runner_rg,
  ]
}
