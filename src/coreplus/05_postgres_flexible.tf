# KV secrets flex server
data "azurerm_key_vault_secret" "pgres_flex_admin_login" {
  name         = "pgres-flex-admin-login"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "pgres_flex_admin_pwd" {
  name         = "pgres-flex-admin-pwd"
  key_vault_id = data.azurerm_key_vault.kv.id
}

#------------------------------------------------
resource "azurerm_resource_group" "postgres_dbs" {
  name     = "${local.program}-postgres-dbs-rg"
  location = var.location

  tags = var.tags
}

# Postgres Flexible Server subnet
module "postgres_flexible_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.3.1"
  name                                      = "${local.program}-pgres-flexible-snet"
  address_prefixes                          = var.cidr_subnet_flex_dbms
  resource_group_name                       = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = data.azurerm_virtual_network.vnet.name
  service_endpoints                         = ["Microsoft.Storage"]
  private_endpoint_network_policies_enabled = true

  delegation = {
    name = "delegation"
    service_delegation = {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}



# https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compare-single-server-flexible-server
module "postgres_flexible_server_private" {

  count = var.pgflex_private_config.enabled ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//postgres_flexible_server?ref=v6.3.1"

  name                = "${local.program}-private-pgflex"
  location            = azurerm_resource_group.postgres_dbs.location
  resource_group_name = azurerm_resource_group.postgres_dbs.name

  ### Network
  private_endpoint_enabled = false
  private_dns_zone_id      = data.azurerm_private_dns_zone.privatelink_postgres_database_azure_com.id
  delegated_subnet_id      = module.postgres_flexible_snet.id

  ### Admin
  administrator_login    = data.azurerm_key_vault_secret.pgres_flex_admin_login.value
  administrator_password = data.azurerm_key_vault_secret.pgres_flex_admin_pwd.value

  sku_name   = "B_Standard_B1ms"
  db_version = "13"
  # Possible values are 32768, 65536, 131072, 262144, 524288, 1048576,
  # 2097152, 4194304, 8388608, 16777216, and 33554432.
  storage_mb = 32768

  ### zones & HA
  zone                      = 1
  high_availability_enabled = false
  standby_availability_zone = 3

  maintenance_window_config = {
    day_of_week  = 0
    start_hour   = 2
    start_minute = 0
  }

  ### backup
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  pgbouncer_enabled = false

  tags = var.tags

  custom_metric_alerts = var.pgflex_public_metric_alerts
  alerts_enabled       = true

  diagnostic_settings_enabled               = true
  log_analytics_workspace_id                = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  diagnostic_setting_destination_storage_id = data.azurerm_storage_account.security_monitoring_storage.id
}

#
# Public Flexible
#

# https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compare-single-server-flexible-server
module "postgres_flexible_server_public" {

  count = var.pgflex_public_config.enabled ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//postgres_flexible_server?ref=v6.3.1"

  name                = "${local.program}-public-pgflex"
  location            = azurerm_resource_group.postgres_dbs.location
  resource_group_name = azurerm_resource_group.postgres_dbs.name

  administrator_login    = data.azurerm_key_vault_secret.pgres_flex_admin_login.value
  administrator_password = data.azurerm_key_vault_secret.pgres_flex_admin_pwd.value

  sku_name   = "B_Standard_B1ms"
  db_version = "13"
  # Possible values are 32768, 65536, 131072, 262144, 524288, 1048576,
  # 2097152, 4194304, 8388608, 16777216, and 33554432.
  storage_mb                   = 32768
  zone                         = 1
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  high_availability_enabled = false
  private_endpoint_enabled  = false
  pgbouncer_enabled         = true

  tags = var.tags

  custom_metric_alerts = var.pgflex_public_metric_alerts
  alerts_enabled       = false

  diagnostic_settings_enabled               = false
  log_analytics_workspace_id                = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  diagnostic_setting_destination_storage_id = data.azurerm_storage_account.security_monitoring_storage.id

}
