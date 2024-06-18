resource "azurerm_resource_group" "sec_rg" {
  name     = "${local.project_ita}-sec-rg"
  location = var.location_ita

  tags = var.tags
}

module "key_vault_core_ita" {
  source              = "github.com/pagopa/terraform-azurerm-v3.git//key_vault?ref=v8.13.0"
  name                = "${local.project_ita}-core-kv"
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = var.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_admin_policy" {
  key_vault_id = module.key_vault_core_ita.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Encrypt", "Decrypt", "GetRotationPolicy", "Purge", "Recover", "Restore"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Restore"]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover"]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {
  key_vault_id = module.key_vault_core_ita.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions         = var.env_short == "d" ? ["Get", "List", "Update", "Create", "Import", "Delete", ] : ["Get", "List", "Update", "Create", "Import", ]
  secret_permissions      = var.env_short == "d" ? ["Get", "List", "Set", "Delete", ] : ["Get", "List", "Set", ]
  storage_permissions     = []
  certificate_permissions = var.env_short == "d" ? ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ] : ["Get", "List", "Update", "Create", "Import", "Restore", "Recover", ]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  count = var.env_short == "d" ? 1 : 0

  key_vault_id = module.key_vault_core_ita.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_externals.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "adgroup_security_policy" {
  count = var.env_short == "d" ? 1 : 0

  key_vault_id = module.key_vault_core_ita.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_security.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}
