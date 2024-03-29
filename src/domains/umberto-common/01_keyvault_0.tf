resource "azurerm_resource_group" "sec_rg_domain" {
  name     = "${local.product}-${var.domain}-sec-rg"
  location = var.location

  tags = var.tags
}

module "key_vault_domain" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault?ref=v7.7.0"

  name                       = "${local.product}-${var.domain}-kv"
  location                   = azurerm_resource_group.sec_rg_domain.location
  resource_group_name        = azurerm_resource_group.sec_rg_domain.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90
  sku_name                   = "premium"

  lock_enable = true

  tags = var.tags
}

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_admin_group_policy" {
  key_vault_id = module.key_vault_domain.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_admin.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}

#
# policy developers
#
resource "azurerm_key_vault_access_policy" "adgroup_developers_policy" {

  key_vault_id = module.key_vault_domain.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions         = var.env_short == "d" ? ["Get", "List", "Update", "Create", "Import", "Delete", ] : ["Get", "List", "Update", "Create", "Import", ]
  secret_permissions      = var.env_short == "d" ? ["Get", "List", "Set", "Delete", ] : ["Get", "List", "Set", ]
  storage_permissions     = []
  certificate_permissions = var.env_short == "d" ? ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", "ManageContacts", ] : ["Get", "List", "Update", "Create", "Import", "Restore", "Recover", ]
}

#
# policy externals
#

resource "azurerm_key_vault_access_policy" "adgroup_externals_policy" {
  count = var.env_short == "d" ? 1 : 0

  key_vault_id = module.key_vault_domain.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_group.adgroup_developers.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", "ManageContacts", ]
}

#
# IaC
#

#pagopaspa-dvopla-platform-iac-projects-{subscription}
data "azuread_service_principal" "platform_iac_sp" {
  display_name = "pagopaspa-devops-platform-iac-projects-${data.azurerm_subscription.current.subscription_id}"
}

resource "azurerm_key_vault_access_policy" "azdevops_platform_iac_policy" {
  key_vault_id = module.key_vault_domain.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.platform_iac_sp.object_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get", ]

  storage_permissions = []
}

#azdo-sp-plan-devopslab-<env>
data "azuread_service_principal" "iac_sp_plan" {
  display_name = "azdo-sp-plan-devopslab-${var.env}"
}

resource "azurerm_key_vault_access_policy" "iac_sp_plan_policy" {
  key_vault_id = module.key_vault_domain.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.iac_sp_plan.object_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get", "Import"]

  storage_permissions = []
}
