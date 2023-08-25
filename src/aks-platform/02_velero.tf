resource "azurerm_resource_group" "velero_rg" {
  location = var.location
  name     = local.velero_rg_name
}


module "velero_storage_account" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v7.2.0"

  name = "${var.prefix}velerosa"

  account_kind                    = "BlobStorage"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  blob_versioning_enabled         = true
  resource_group_name             = azurerm_resource_group.velero_rg.name
  location                        = var.location
  allow_nested_items_to_be_public = true
  advanced_threat_protection      = true
  enable_low_availability_alert   = false
  public_network_access_enabled   = true
  tags                            = var.tags


}

resource "azurerm_storage_container" "velero_backup_container" {
  name                  = "velero-backup"
  storage_account_name  = module.velero_storage_account.name
  container_access_type = "private"

}


data "azuread_client_config" "current" {}

resource "azuread_application" "sp_applicaiton" {
  display_name     = "velero-sp"
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "sp" {
  application_id    = azuread_application.sp_applicaiton.application_id
  owners            = [data.azuread_client_config.current.object_id]
}


resource "azuread_service_principal_password" "sp_password" {
  service_principal_id = azuread_service_principal.sp.object_id
}


resource "azurerm_role_assignment" "sp_role" {
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}


resource "local_file" "credentials" {
  content  = templatefile("./velero-credentials.tpl", {
    subscription_id = data.azurerm_subscription.current.subscription_id
    tenant_id = data.azurerm_subscription.current.tenant_id
    client_id = azuread_service_principal.sp.id
    client_secret = azuread_service_principal_password.sp_password.value
    backup_rg = azurerm_resource_group.velero_rg.name
  })
  filename = "${path.module}/credentials-velero.txt"
}


resource "null_resource" "install_velero" {
  depends_on = [local_file.credentials]

  triggers = {
    bucket = azurerm_storage_container.velero_backup_container.name
    storage_account = module.velero_storage_account.id
    rg = azurerm_resource_group.velero_rg.name
    subscription_id = data.azurerm_subscription.current.subscription_id
    credentials = filemd5(local_file.credentials.filename)
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
    velero uninstall --force
    EOT
  }

  provisioner "local-exec" {
    command     = <<EOT
    velero install --provider azure --plugins velero/velero-plugin-for-microsoft-azure:v1.5.0 \
    --bucket ${azurerm_storage_container.velero_backup_container.name} \
    --secret-file ${local_file.credentials.filename} \
    --backup-location-config resourceGroup=${azurerm_resource_group.velero_rg.name},storageAccount=${module.velero_storage_account.id},subscriptionId=${data.azurerm_subscription.current.subscription_id} \
    # funziona?
    --use-restic
    # to test
    --set configuration.backupStorageLocation.config.subscriptionId=$AZURE_SUBSCRIPTION_ID
    --set configuration.volumeSnapshotLocation.config.resourceGroup=$STORAGE_RESOURCE_GROUP
    --set configuration.volumeSnapshotLocation.config.subscriptionId=$AZURE_SUBSCRIPTION_ID
    EOT
  }
}



