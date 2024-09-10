## Resource Group
resource "azurerm_resource_group" "rg_velero" {
  name     = "${local.project}-velero-rg"
  location = var.location
  tags     = var.tags
}

# Workload identity init
module "velero_workload_identity_init" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity_init?ref=velero-workload-identity"

  workload_identity_location            = var.location
  workload_identity_name_prefix         = "velero"
  workload_identity_resource_group_name = azurerm_resource_group.rg_velero.name
}

resource "kubernetes_namespace" "velero_namespace" {
  metadata {
    name = "velero"
  }
}

# Cluster Velero + Workload identity configuration
module "velero_aks_workload_identity" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_cluster_velero?ref=velero-workload-identity"

  prefix          = var.prefix
  location        = var.location
  subscription_id = data.azurerm_client_config.current.subscription_id

  aks_cluster_name                      = local.aks_cluster_name
  aks_cluster_rg                        = local.aks_rg_name
  workload_identity_name                = module.velero_workload_identity_init.user_assigned_identity_name
  workload_identity_resource_group_name = azurerm_resource_group.rg_velero.name

  key_vault_id = data.azurerm_key_vault.kv_core_ita.id

  storage_account_resource_group_name = azurerm_resource_group.rg_velero.name
  private_endpoint_subnet_id          = azurerm_subnet.user_aks_subnet.id
  storage_account_private_dns_zone_id = data.azurerm_private_dns_zone.storage_account_private_dns_zone.id
  tags                                = {}
}

resource "azurerm_role_assignment" "velero_workload_identity_role" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.velero_workload_identity_init.workload_identity_principal_id
}
