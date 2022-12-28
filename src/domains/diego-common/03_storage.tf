resource "azurerm_resource_group" "diego_storage_rg" {
  name     = "${local.product}-${var.domain}-storage-rg"
  location = var.location

  tags = var.tags
}

module "diego_storage_account" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v3.4.1"

  name                            = replace("${local.product}-${var.domain}-st", "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  blob_versioning_enabled         = true
  resource_group_name             = azurerm_resource_group.diego_storage_rg.name
  location                        = var.location
  advanced_threat_protection      = false
  allow_nested_items_to_be_public = false

  blob_delete_retention_days      = 9
  container_delete_retention_days = 8

  tags = var.tags
}
