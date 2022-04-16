data "azurerm_public_ip" "aks_ephemeral_outbound_ip" {
  count = var.aks_ephemeral_num_outbound_ips

  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  name                = "${local.aks_ephemeral_public_ip_name}-${count.index + 1}"
}

#--------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "aks_ephemeral_rg" {
  name     = local.aks_ephemeral_rg_name
  location = var.location
  tags     = var.tags
}

# k8s cluster subnet
module "aks_ephemeral_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.8.1"
  name                                           = "${local.project}-aks-ephemeral-snet"
  address_prefixes                               = var.cidr_subnet_aks_ephemeral
  resource_group_name                            = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = data.azurerm_virtual_network.vnet.name
  enforce_private_link_endpoint_network_policies = var.aks_ephemeral_private_cluster_enabled

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]
}

module "aks_ephemeral" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=DEVOPS-246-aks-improvements"

  count = var.aks_ephemeral_enabled ? 1 : 0

  name                       = local.aks_ephemeral_cluster_name
  location                   = azurerm_resource_group.aks_ephemeral_rg.location
  dns_prefix                 = "${local.project}-aks-ephemeral"
  resource_group_name        = azurerm_resource_group.aks_ephemeral_rg.name
  kubernetes_version         = var.aks_ephemeral_kubernetes_version
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  sku_tier                   = var.aks_ephemeral_sku_tier

  #
  # 🤖 System node pool
  #
  system_node_pool_name = var.aks_ephemeral_system_node_pool.name
  ### vm configuration
  system_node_pool_vm_size         = var.aks_ephemeral_system_node_pool.vm_size
  system_node_pool_os_disk_type    = var.aks_ephemeral_system_node_pool.os_disk_type
  system_node_pool_os_disk_size_gb = var.aks_ephemeral_system_node_pool.os_disk_size_gb
  system_node_pool_node_count_min  = var.aks_ephemeral_system_node_pool.node_count_min
  system_node_pool_node_count_max  = var.aks_ephemeral_system_node_pool.node_count_max
  ### K8s node configuration
  system_node_pool_node_labels = var.aks_ephemeral_system_node_pool.node_labels
  system_node_pool_tags        = var.aks_ephemeral_system_node_pool.node_tags

  #
  # 👤 User node pool
  #
  user_node_pool_enabled = var.aks_ephemeral_user_node_pool.enabled
  user_node_pool_name    = var.aks_ephemeral_user_node_pool.name
  ### vm configuration
  user_node_pool_vm_size         = var.aks_ephemeral_user_node_pool.vm_size
  user_node_pool_os_disk_type    = var.aks_ephemeral_user_node_pool.os_disk_type
  user_node_pool_os_disk_size_gb = var.aks_ephemeral_user_node_pool.os_disk_size_gb
  user_node_pool_node_count_min  = var.aks_ephemeral_user_node_pool.node_count_min
  user_node_pool_node_count_max  = var.aks_ephemeral_user_node_pool.node_count_max
  ### K8s node configuration
  user_node_pool_node_labels = var.aks_ephemeral_user_node_pool.node_labels
  user_node_pool_node_taints = var.aks_ephemeral_user_node_pool.node_taints
  user_node_pool_tags        = var.aks_ephemeral_user_node_pool.node_tags
  # end user node pool

  #
  # ☁️ Network
  #
  vnet_id        = data.azurerm_virtual_network.vnet.id
  vnet_subnet_id = module.aks_ephemeral_snet.id

  outbound_ip_address_ids = data.azurerm_public_ip.aks_ephemeral_outbound_ip.*.id
  private_cluster_enabled = var.aks_ephemeral_private_cluster_enabled
  network_profile = {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.2.0.10"
    network_plugin     = "azure"
    network_policy     = "azure"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.2.0.0/16"
  }
  # end network

  rbac_enabled        = true
  aad_admin_group_ids = var.env_short == "d" ? [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id] : [data.azuread_group.adgroup_admin.object_id]

  addon_azure_policy_enabled                    = var.aks_ephemeral_addons.azure_policy
  # addon_azure_keyvault_secrets_provider_enabled = var.aks_ephemeral_addons.azure_keyvault_secrets_provider
  addon_azure_pod_identity_enabled              = var.aks_ephemeral_addons.pod_identity_enabled

  metric_alerts  = var.aks_ephemeral_metric_alerts
  alerts_enabled = var.aks_ephemeral_alerts_enabled
  action = [
    {
      action_group_id    = data.azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = data.azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]
  tags = var.tags
}
