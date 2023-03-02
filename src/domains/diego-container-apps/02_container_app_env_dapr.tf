# Subnet to host the api config
module "container_apps_dapr_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v5.3.0"
  name                 = "${local.project}-container-apps-dapr-snet"
  address_prefixes     = var.cidr_subnet_container_apps_dapr
  virtual_network_name = data.azurerm_virtual_network.vnet_core.name

  resource_group_name                       = data.azurerm_resource_group.rg_vnet_core.name
  private_endpoint_network_policies_enabled = true
}

resource "null_resource" "container_app_dapr_create_env" {
  triggers = {
    env_name                                   = local.container_app_dapr_environment_name
    rg                                         = azurerm_resource_group.container_app_diego.name
    subnet_id                                  = module.container_apps_dapr_snet.id
    log_analytics_id                           = data.azurerm_log_analytics_workspace.log_analytics.workspace_id
    log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  }

  provisioner "local-exec" {
    command = <<EOT
      az containerapp env create \
          -n ${local.container_app_dapr_environment_name} \
          -g ${azurerm_resource_group.container_app_diego.name} \
          --location ${var.location} \
          --infrastructure-subnet-resource-id ${module.container_apps_dapr_snet.id} \
          --internal-only false \
          --logs-destination log-analytics \
          --logs-workspace-id "${data.azurerm_log_analytics_workspace.log_analytics.workspace_id}" \
          --logs-workspace-key "${data.azurerm_log_analytics_workspace.log_analytics.primary_shared_key}"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOD
      az containerapp env delete \
          -n ${self.triggers.env_name} \
          -g ${self.triggers.rg} \
          -y --no-wait
EOD
  }

  depends_on = [
    module.container_apps_dapr_snet,
    azurerm_resource_group.container_app_diego
  ]
}

locals {
  container_app_env_darp_cosmosdb_yaml_content = templatefile("${path.module}/container-app-env/cosmosdb-component-dapr.yaml.tpl", {
    COSMOSDB_KEY                     = azurerm_cosmosdb_account.mongodb.primary_key
  })
}

resource "local_file" "save_yaml_file_cosmosdb_component" {
  content  = local.container_app_env_darp_cosmosdb_yaml_content
  filename = local.container_app_dapr_environment_component_cosmosdb
}

resource "null_resource" "container_app_env_darp_cosmosdb_yaml" {

  triggers = {
    CONTENT_FILE = local.container_app_env_darp_cosmosdb_yaml_content
  }

  provisioner "local-exec" {
    command = <<EOT
      az containerapp env dapr-component set --dapr-component-name cosmosdb \
        --name ${local.container_app_dapr_environment_name} \
        --resource-group ${azurerm_resource_group.container_app_diego.name} \
        --yaml "${local.container_app_dapr_environment_component_cosmosdb}"
    EOT
  }

  depends_on = [
    local_file.save_yaml_file_cosmosdb_component,
    null_resource.container_app_dapr_create_env,
  ]
}
