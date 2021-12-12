# resource "azurerm_private_dns_zone" "internal" {
#   count               = (var.dns_zone_prefix == null || var.external_domain == null) ? 0 : 1
#   name                = local.dns_zone_private_name
#   resource_group_name = azurerm_resource_group.rg_vnet.name

#   tags = var.tags
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "internal_vnet" {
#   name                  = local.vnet_resource_group
#   resource_group_name   = azurerm_resource_group.rg_vnet.name
#   private_dns_zone_name = azurerm_private_dns_zone.internal[0].name
#   virtual_network_id    = module.vnet.id
# }
