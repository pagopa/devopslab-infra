data "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  name                = "${local.aks_public_ip_name}-${count.index + 1}"
}

#--------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg_aks" {
  name     = local.aks_rg_name
  location = var.location
  tags     = var.tags
}

# k8s cluster subnet
module "k8s_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.8.1"
  name                                           = "${local.project}-k8s-snet"
  address_prefixes                               = var.cidr_subnet_k8s
  resource_group_name                            = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = data.azurerm_virtual_network.vnet.name
  enforce_private_link_endpoint_network_policies = var.aks_private_cluster_enabled

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]
}

module "aks" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=v2.13.1"

  name                = local.aks_cluster_name
  location            = azurerm_resource_group.rg_aks.location
  dns_prefix          = "${local.project}-aks"
  resource_group_name = azurerm_resource_group.rg_aks.name
  kubernetes_version  = var.kubernetes_version

  system_node_pool_name            = var.aks_system_node_pool.name
  system_node_pool_vm_size         = var.aks_system_node_pool.vm_size
  system_node_pool_os_disk_type    = var.aks_system_node_pool.os_disk_type
  system_node_pool_os_disk_size_gb = var.aks_system_node_pool.os_disk_size_gb
  system_node_pool_node_count_min  = var.aks_system_node_pool.node_count_min
  system_node_pool_node_count_max  = var.aks_system_node_pool.node_count_max
  system_node_pool_node_labels     = var.aks_system_node_pool.node_labels
  system_node_pool_tags            = var.aks_system_node_pool.node_tags

  system_node_pool_only_critical_addons_enabled = true

  user_node_pool_enabled         = var.aks_user_node_pool.enabled
  user_node_pool_name            = var.aks_user_node_pool.name
  user_node_pool_vm_size         = var.aks_user_node_pool.vm_size
  user_node_pool_os_disk_type    = var.aks_user_node_pool.os_disk_type
  user_node_pool_os_disk_size_gb = var.aks_user_node_pool.os_disk_size_gb
  user_node_pool_node_count_min  = var.aks_user_node_pool.node_count_min
  user_node_pool_node_count_max  = var.aks_user_node_pool.node_count_max
  user_node_pool_node_labels     = var.aks_user_node_pool.node_labels
  user_node_pool_node_taints     = var.aks_user_node_pool.node_taints
  user_node_pool_tags            = var.aks_user_node_pool.node_tags

  vnet_id        = data.azurerm_virtual_network.vnet.id
  vnet_subnet_id = module.k8s_snet.id

  outbound_ip_address_ids = data.azurerm_public_ip.aks_outbound.*.id
  private_cluster_enabled = var.aks_private_cluster_enabled

  network_profile = {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.2.0.10"
    network_plugin     = "azure"
    network_policy     = "azure"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.2.0.0/16"
  }

  rbac_enabled        = true
  aad_admin_group_ids = var.env_short == "d" ? [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id] : [data.azuread_group.adgroup_admin.object_id]

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id

  addon_azure_policy_enabled                     = var.aks_addons.azure_policy
  addon_azure_key_vault_secrets_provider_enabled = var.aks_addons.azure_key_vault_secrets_provider
  addon_azure_pod_identity_enabled               = var.aks_addons.pod_identity_enabled

  metric_alerts  = var.aks_metric_alerts
  alerts_enabled = var.aks_alerts_enabled

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

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_id
}

resource "azurerm_key_vault_secret" "aks_apiserver_url" {
  name         = "aks-apiserver-url"
  value        = "https://${module.aks.fqdn}"
  key_vault_id = data.azurerm_key_vault.kv.id
}
