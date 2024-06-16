resource "azurerm_kubernetes_cluster_node_pool" "user_nodepool_testit" {
  count = var.is_feature_enabled.nodepool_dedicated ? 1 : 0

  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id

  name = var.aks_user_node_pool_testit.name

  ### vm configuration
  vm_size = var.aks_user_node_pool_testit.vm_size
  # https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general
  os_disk_type           = var.aks_user_node_pool_testit.os_disk_type # Managed or Ephemeral
  os_disk_size_gb        = var.aks_user_node_pool_testit.os_disk_size_gb
  zones                  = var.aks_user_node_pool_testit.zones
  ultra_ssd_enabled      = var.aks_user_node_pool_testit.ultra_ssd_enabled
  enable_host_encryption = var.aks_user_node_pool_testit.enable_host_encryption
  os_type                = "Linux"

  ### autoscaling
  enable_auto_scaling = true
  node_count          = var.aks_user_node_pool_testit.node_count_min
  min_count           = var.aks_user_node_pool_testit.node_count_min
  max_count           = var.aks_user_node_pool_testit.node_count_max

  ### K8s node configuration
  max_pods    = var.aks_user_node_pool_testit.max_pods
  node_labels = var.aks_user_node_pool_testit.node_labels
  node_taints = var.aks_user_node_pool_testit.node_taints

  ### networking
  vnet_subnet_id        = azurerm_subnet.user_testit_subnet.id
  enable_node_public_ip = false

  upgrade_settings {
    max_surge = var.aks_user_node_pool_testit.upgrade_settings_max_surge
  }

  tags = merge(var.tags, var.aks_user_node_pool_testit.node_tags)

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
