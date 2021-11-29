locals {
  postgres = {
    metric_alerts = {
      cpu = {
        aggregation = "Average"
        metric_name = "cpu_percent"
        operator    = "GreaterThan"
        threshold   = 70
        frequency   = "PT1M"
        window_size = "PT5M"
        dimension   = []
      }
      memory = {
        aggregation = "Average"
        metric_name = "memory_percent"
        operator    = "GreaterThan"
        threshold   = 75
        frequency   = "PT1M"
        window_size = "PT5M"
        dimension   = []
      }
      io = {
        aggregation = "Average"
        metric_name = "io_consumption_percent"
        operator    = "GreaterThan"
        threshold   = 55
        frequency   = "PT1M"
        window_size = "PT5M"
        dimension   = []
      }
      # https://docs.microsoft.com/it-it/azure/postgresql/concepts-limits
      # GP_Gen5_2 -| 145 / 100 * 80 = 116
      # GP_Gen5_32 -| 1495 / 100 * 80 = 1196
      max_active_connections = {
        aggregation = "Average"
        metric_name = "active_connections"
        operator    = "GreaterThan"
        threshold   = 1196
        frequency   = "PT5M"
        window_size = "PT5M"
        dimension   = []
      }
      min_active_connections = {
        aggregation = "Average"
        metric_name = "active_connections"
        operator    = "LessThanOrEqual"
        threshold   = 0
        frequency   = "PT5M"
        window_size = "PT15M"
        dimension   = []
      }
      failed_connections = {
        aggregation = "Total"
        metric_name = "connections_failed"
        operator    = "GreaterThan"
        threshold   = 10
        frequency   = "PT5M"
        window_size = "PT15M"
        dimension   = []
      }
      replica_lag = {
        aggregation = "Average"
        metric_name = "pg_replica_log_delay_in_seconds"
        operator    = "GreaterThan"
        threshold   = 60
        frequency   = "PT1M"
        window_size = "PT5M"
        dimension   = []
      }
    }
  }
}

data "azurerm_key_vault_secret" "postgres_administrator_login" {
  name         = "postgres-administrator-login"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "postgres_administrator_login_password" {
  name         = "postgres-administrator-login-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_resource_group" "data_rg" {
  name     = format("%s-data-rg", local.project)
  location = var.location

  tags = var.tags
}

## Database subnet
module "postgres_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.84"
  name                                           = format("%s-postgres-snet", local.project)
  address_prefixes                               = var.cidr_subnet_postgres
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  service_endpoints                              = ["Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}

module "postgres" {
  source = "git::https://github.com/pagopa/azurerm.git//postgresql_server?ref=v2.0.0"

  name                = format("%s-postgres", local.project)
  location            = azurerm_resource_group.data_rg.location
  resource_group_name = azurerm_resource_group.data_rg.name

  administrator_login          = data.azurerm_key_vault_secret.postgres_administrator_login.value
  administrator_login_password = data.azurerm_key_vault_secret.postgres_administrator_login_password.value
  sku_name                     = var.postgres_sku_name
  db_version                   = 11
  geo_redundant_backup_enabled = var.postgres_geo_redundant_backup_enabled

  public_network_access_enabled = var.env_short == "p" ? false : var.postgres_public_network_access_enabled
  network_rules                 = var.postgres_network_rules
  private_endpoint = {
    enabled              = var.postgres_private_endpoint_enabled
    virtual_network_id   = azurerm_resource_group.rg_vnet.id
    subnet_id            = module.postgres_snet.id
    private_dns_zone_ids = [azurerm_private_dns_zone.privatelink_postgres_database_azure_com.id]
  }

  alerts_enabled                = var.postgres_alerts_enabled
  monitor_metric_alert_criteria = local.postgres.metric_alerts
  action = [
    {
      action_group_id    = azurerm_monitor_action_group.email.id
      webhook_properties = null
    },
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    }
  ]

  lock_enable = var.lock_enable

  tags = var.tags
}

data "azuread_group" "postgres" {
  display_name = module.postgres.name
}

resource "azurerm_key_vault_access_policy" "postgres" {
  count = var.postgres_byok_enabled ? 1 : 0

  key_vault_id            = data.azurerm_key_vault.kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_group.postgres.object_id
  key_permissions         = ["Get", "WrapKey", "UnwrapKey", ]
  secret_permissions      = []
  certificate_permissions = []
  storage_permissions     = []
}

resource "azurerm_key_vault_key" "postgres" {
  count = var.postgres_byok_enabled ? 1 : 0

  name         = "postgres-key"
  key_vault_id = data.azurerm_key_vault.kv.id
  key_type     = "RSA-HSM"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_postgresql_server_key" "postgres" {
  count      = var.postgres_byok_enabled ? 1 : 0
  depends_on = [azurerm_key_vault_access_policy.postgres]

  server_id        = module.postgres.id
  key_vault_key_id = azurerm_key_vault_key.postgres[0].id
}
