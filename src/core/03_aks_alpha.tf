data "azurerm_public_ip" "aks_alpha_outbound_ip" {
  count = var.aks_alpha_num_outbound_ips

  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  name                = "${local.aks_alpha_public_ip_name}-${count.index + 1}"
}

#--------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "aks_alpha_rg" {
  name     = local.aks_alpha_rg_name
  location = var.location
  tags     = var.tags
}

# k8s cluster subnet
module "aks_alpha_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.8.1"
  name                                           = "${local.project}-k8s-alpha-snet"
  address_prefixes                               = var.cidr_subnet_k8s
  resource_group_name                            = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = data.azurerm_virtual_network.vnet.name
  enforce_private_link_endpoint_network_policies = var.aks_alpha_private_cluster_enabled

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]
}

module "aks_alpha" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=v2.8.1"

  name                       = local.aks_alpha_cluster_name
  location                   = azurerm_resource_group.aks_alpha_rg.location
  dns_prefix                 = "${local.project}-aks-alpha"
  resource_group_name        = azurerm_resource_group.aks_alpha_rg.name
  availability_zones         = var.aks_alpha_availability_zones
  kubernetes_version         = var.aks_alpha_kubernetes_version
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id

  vm_size             = var.aks_alpha_vm_size
  enable_auto_scaling = var.aks_alpha_enable_auto_scaling
  node_count          = var.aks_alpha_node_count
  min_count           = var.aks_alpha_node_min_count
  max_count           = var.aks_alpha_node_max_count
  max_pods            = var.aks_alpha_max_pods
  sku_tier            = var.aks_alpha_sku_tier

  private_cluster_enabled = var.aks_alpha_private_cluster_enabled

  rbac_enabled        = true
  aad_admin_group_ids = var.env_short == "d" ? [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id] : [data.azuread_group.adgroup_admin.object_id]

  vnet_id        = data.azurerm_virtual_network.vnet.id
  vnet_subnet_id = module.aks_alpha_snet.id

  network_profile = {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.2.0.10"
    network_plugin     = "azure"
    network_policy     = "azure"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.2.0.0/16"
  }

  enable_azure_keyvault_secrets_provider = true

  metric_alerts = var.aks_alpha_metric_alerts
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

  alerts_enabled = var.aks_alpha_alerts_enabled

  outbound_ip_address_ids = data.azurerm_public_ip.aks_alpha_outbound_ip.*.id

  tags = var.tags
}

# # add the role to the identity the kubernetes cluster was assigned
# resource "azurerm_role_assignment" "aks_alpha_to_acr" {
#   scope                = data.azurerm_container_registry.acr.id
#   role_definition_name = "AcrPull"
#   principal_id         = module.aks.kubelet_identity_id
# }
