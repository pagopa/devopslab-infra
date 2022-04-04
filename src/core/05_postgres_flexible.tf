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
  name     = "${local.project}-postgres-dbs-rg"
  location = var.location

  tags = var.tags
}

# Postgres Flexible Server subnet
module "postgres_flexible_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.8.1"
  name                                           = "${local.project}-pgres-flexible-snet"
  address_prefixes                               = var.cidr_subnet_flex_dbms
  resource_group_name                            = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = data.azurerm_virtual_network.vnet.name
  service_endpoints                              = ["Microsoft.Storage"]
  enforce_private_link_endpoint_network_policies = true

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

# DNS private single server
resource "azurerm_private_dns_zone" "privatelink_postgres_database_azure_com" {

  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_postgres_database_azure_com_vnet" {

  name                  = "${local.project}-pg-flex-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.name

  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  virtual_network_id  = data.azurerm_virtual_network.vnet.id

  registration_enabled = false

  tags = var.tags
}

# https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compare-single-server-flexible-server
module "postgres_flexible_server_private" {

  count = var.pgflex_private_config.enabled ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//postgres_flexible_server?ref=v2.8.1"

  name                = "${local.project}-private-pgflex"
  location            = azurerm_resource_group.postgres_dbs.location
  resource_group_name = azurerm_resource_group.postgres_dbs.name

  ### Network
  private_endpoint_enabled = var.pgflex_private_config.private_endpoint_enabled
  private_dns_zone_id      = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.id
  delegated_subnet_id      = module.postgres_flexible_snet.id

  ### Admin
  administrator_login    = data.azurerm_key_vault_secret.pgres_flex_admin_login.value
  administrator_password = data.azurerm_key_vault_secret.pgres_flex_admin_pwd.value

  sku_name   = var.pgflex_private_config.sku_name
  db_version = var.pgflex_private_config.db_version
  storage_mb = var.pgflex_private_config.storage_mb

  ### zones & HA
  zone                      = var.pgflex_private_config.zone
  high_availability_enabled = var.pgflex_private_ha_config.high_availability_enabled
  standby_availability_zone = var.pgflex_private_ha_config.standby_availability_zone

  maintenance_window_config = {
    day_of_week  = 0
    start_hour   = 2
    start_minute = 0
  }

  ### backup
  backup_retention_days        = var.pgflex_private_config.backup_retention_days
  geo_redundant_backup_enabled = var.pgflex_private_config.geo_redundant_backup_enabled

  pgbouncer_enabled = var.pgflex_private_config.pgbouncer_enabled

  tags = var.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.privatelink_postgres_database_azure_com_vnet]

}

#
# Public Flexible
#

# https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compare-single-server-flexible-server
module "postgres_flexible_server_public" {

  count = var.pgflex_public_config.enabled ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//postgres_flexible_server?ref=v2.8.1"

  name                = "${local.project}-public-pgflex"
  location            = azurerm_resource_group.postgres_dbs.location
  resource_group_name = azurerm_resource_group.postgres_dbs.name

  administrator_login    = data.azurerm_key_vault_secret.pgres_flex_admin_login.value
  administrator_password = data.azurerm_key_vault_secret.pgres_flex_admin_pwd.value

  sku_name                     = var.pgflex_public_config.sku_name
  db_version                   = var.pgflex_public_config.db_version
  storage_mb                   = var.pgflex_public_config.storage_mb
  zone                         = var.pgflex_public_config.zone
  backup_retention_days        = var.pgflex_public_config.backup_retention_days
  geo_redundant_backup_enabled = var.pgflex_public_config.geo_redundant_backup_enabled

  high_availability_enabled = var.pgflex_public_ha_config.high_availability_enabled
  private_endpoint_enabled  = var.pgflex_public_config.private_endpoint_enabled
  pgbouncer_enabled         = var.pgflex_public_config.pgbouncer_enabled

  tags = var.tags

}
