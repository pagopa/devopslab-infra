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

#
# KeyVault
#
resource "random_password" "pg_admin_password" {
  length           = 8
  special          = true
  upper            = false
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "-"
}

resource "azurerm_key_vault_secret" "pg_admin_password" {

  name         = "pg-admin-password"
  value        = random_password.pg_admin_password.result
  content_type = "text/plain"

  key_vault_id = module.key_vault_core_ita.id
}

resource "azurerm_key_vault_secret" "pg_admin_user" {

  name         = "pg-admin-user"
  value        = "postgres"
  content_type = "text/plain"

  key_vault_id = module.key_vault_core_ita.id
}

#--------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "data_rg" {
  name     = "${local.project}-data-rg"
  location = var.location_ita

  tags = var.tags
}

## Database subnet
module "postgres_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet"
  name                                      = "${local.project}-postgres-snet"
  address_prefixes                          = var.cidr_subnet_postgres
  resource_group_name                       = azurerm_resource_group.rg_ita_vnet.name
  virtual_network_name                      = module.vnet_italy.name
  service_endpoints                         = ["Microsoft.Sql"]
  private_endpoint_network_policies_enabled = true
}

module "postgres" {
  count  = var.is_resource_core_enabled.postgresql_server ? 1 : 0
  source = "./.terraform/modules/__v3__/postgresql_server"

  name                = "${local.project}-postgres"
  location            = azurerm_resource_group.data_rg.location
  resource_group_name = azurerm_resource_group.data_rg.name

  administrator_login          = azurerm_key_vault_secret.pg_admin_user.value
  administrator_login_password = azurerm_key_vault_secret.pg_admin_password.value
  sku_name                     = "B_Gen5_1"
  db_version                   = 11
  geo_redundant_backup_enabled = false

  public_network_access_enabled = var.env_short == "p" ? false : var.postgres_public_network_access_enabled
  network_rules                 = var.postgres_network_rules
  private_endpoint = {
    enabled              = false
    virtual_network_id   = azurerm_resource_group.rg_ita_vnet.id
    subnet_id            = module.postgres_snet.id
    private_dns_zone_ids = []
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
