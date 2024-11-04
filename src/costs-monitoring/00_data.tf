data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_cluster_name
  resource_group_name = local.aks_rg_name
}

data "azurerm_private_dns_zone" "internal_dbs_zone" {
  name                = "internal.devopslab.pagopa.it"
  resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-vnet-rg"
}
