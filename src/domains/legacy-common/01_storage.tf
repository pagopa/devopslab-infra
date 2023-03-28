resource "azurerm_resource_group" "rg_storage" {
  name     = "${local.project}-storage-rg"
  location = var.location

  tags = var.tags
}

module "backupstorage" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=fix-storage-account-versioning"

  name                                         = replace(format("%s-bckst", local.project), "-", "")
  resource_group_name                          = azurerm_resource_group.rg_storage.name
  account_kind                                 = "StorageV2"
  account_tier                                 = "Standard"
  account_replication_type                     = "GRS"
  access_tier                                  = "Cool"
  enable_versioning                            = true
  location                                     = var.location
  allow_blob_public_access                     = false
  advanced_threat_protection                   = true
  enable_low_availability_alert                = false
  blob_properties_delete_retention_policy_days = 365

  tags = var.tags
}

module "dummy" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=fix-storage-account-versioning"

  name                                         = replace(format("%s-dumst", local.project), "-", "")
  resource_group_name                          = azurerm_resource_group.rg_storage.name
  account_kind                                 = "StorageV2"
  account_tier                                 = "Standard"
  account_replication_type                     = "GRS"
  access_tier                                  = "Cool"
  enable_versioning                            = true
  location                                     = var.location
  allow_blob_public_access                     = false
  advanced_threat_protection                   = true
  enable_low_availability_alert                = false
  blob_properties_delete_retention_policy_days = 365



  tags = var.tags
}
