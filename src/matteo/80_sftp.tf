# To fully configure the storage account, there are some manual steps. See
# https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/511738518/Enable+SFTP+with+Azure+Storage+Account

module "sftp" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.18.0"

  name                = replace("${local.project}-sftp", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  is_hns_enabled           = true

  tags = var.tags
}

resource "azurerm_storage_share" "stress_files" {
  name                  = "stress-files"
  storage_account_name  = module.sftp.name
}

resource "azurerm_storage_container" "ade" {
  name                  = "ade"
  storage_account_name  = module.sftp.name
  container_access_type = "private"
}

# resource "kubernetes_manifest" "users_key" {
#   manifest = yamldecode(templatefile("${path.module}/sftp/k8s/users_key.yaml.tpl", {
#     namespace          = kubernetes_namespace.sftp.metadata[0].name
#     matteo_private_key = base64encode(data.azurerm_key_vault_secret.sftp_private_key.value)
#   }))
# }
#
# resource "kubernetes_manifest" "volume_secrets" {
#   manifest = yamldecode(templatefile("${path.module}/sftp/k8s/volume_secrets.yaml.tpl", {
#     namespace    = kubernetes_namespace.sftp.metadata[0].name
#     account_name = base64encode(data.azurerm_key_vault_secret.sftp_account_name.value)
#     account_key  = base64encode(data.azurerm_key_vault_secret.sftp_account_key.value)
#   }))
# }
#
# resource "kubernetes_manifest" "job" {
#   manifest = yamldecode(templatefile("${path.module}/sftp/k8s/job.yaml.tpl", {
#     namespace   = kubernetes_namespace.sftp.metadata[0].name
#     label       = "1mb"
#     destination = "dvopladsftp.${azurerm_storage_container.ade.name}.matteo@dvopladsftp.blob.core.windows.net"
#     username    = "matteo"
#     filename    = "1MB"
#     schedule    = "* * * * *"
#   }))
# }
