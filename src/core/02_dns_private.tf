#
# internal.devopslab...
#
resource "azurerm_private_dns_zone" "internal_devopslab" {
  count               = (var.dns_zone_internal_prefix == null || var.external_domain == null) ? 0 : 1
  name                = local.dns_zone_private_name
  resource_group_name = local.vnet_ita_resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_core" {
  name                  = local.vnet_resource_group_name
  resource_group_name   = local.vnet_ita_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.internal_devopslab[0].name
  virtual_network_id    = module.vnet.id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_italy" {
  name                  = local.vnet_ita_name
  resource_group_name   = local.vnet_ita_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.internal_devopslab[0].name
  virtual_network_id    = data.azurerm_virtual_network.vnet_ita_core.id

  tags = var.tags
}

# DNS private single server
resource "azurerm_private_dns_zone" "privatelink_postgres_database_azure_com" {

  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = local.vnet_ita_resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_postgres_database_azure_com_vnet" {

  name                  = "${local.project}-pg-flex-link"
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.name

  resource_group_name = local.vnet_ita_resource_group_name
  virtual_network_id  = module.vnet.id

  registration_enabled = false

  tags = var.tags
}


resource "azurerm_private_dns_zone" "storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.vnet_ita_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_account_vnet" {
  name                  = "${local.project}-storage-account-vnet-private-dns-zone-link"
  resource_group_name   = local.vnet_ita_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = module.vnet.id
}
