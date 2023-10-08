# module "aks_storage_class" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_storage_class?ref=v7.10.0"
# }

# module "velero" {
#   source                              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_cluster_velero?ref=v7.7.1"
#   count                               = var.aks_enabled ? 1 : 0
#   backup_storage_container_name       = "velero-backup"
#   subscription_id                     = data.azurerm_subscription.current.subscription_id
#   tenant_id                           = data.azurerm_subscription.current.tenant_id
#   resource_group_name                 = azurerm_resource_group.rg_aks_backup.name
#   prefix                              = "devopla"
#   aks_cluster_name                    = module.aks_pci[count.index].name
#   aks_cluster_rg                      = azurerm_resource_group.rg_aks.name
#   location                            = var.location
#   use_storage_private_endpoint        = true
#   private_endpoint_subnet_id          = data.azurerm_subnet.private_endpoint_subnet.id
#   storage_account_private_dns_zone_id = data.azurerm_private_dns_zone.storage_account_private_dns_zone.id

#   tags = var.tags
# }

# module "aks_namespace_backup" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_velero_backup?ref=v7.7.0"
#   count  = var.aks_enabled ? 1 : 0
#   # required
#   backup_name      = "daily-backup"
#   namespaces       = ["ALL"]
#   aks_cluster_name = module.aks_pci[count.index].name

#   # optional
#   ttl             = "72h0m0s"
#   schedule        = "0 3 * * *" #refers to UTC timezone
#   volume_snapshot = false

#   depends_on = [
#     module.velero
#   ]
# }
