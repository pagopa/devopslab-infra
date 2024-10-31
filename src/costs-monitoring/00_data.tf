data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_cluster_name
  resource_group_name = local.aks_rg_name
}
