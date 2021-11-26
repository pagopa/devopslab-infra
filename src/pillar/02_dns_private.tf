resource "azurerm_private_dns_zone" "internal" {
  count               = (var.dns_zone_prefix == null || var.external_domain == null) ? 0 : 1
  name                = join(".", ["internal", var.dns_zone_prefix, var.external_domain])
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "internal_vnet" {
  name                  = format("%s-vnet", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.internal[0].name
  virtual_network_id    = module.vnet.id
}

resource "azurerm_private_dns_zone" "privatelink_postgres_database_azure_com" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_postgres_database_azure_com_vnet" {
  name                  = module.vnet.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.name
  virtual_network_id    = module.vnet.id
  registration_enabled  = false

  tags = var.tags
}
