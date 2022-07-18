module "backup_feature" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.18.0"

  name                = replace("${local.project}-matteo-backup", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  tags = var.tags
}
