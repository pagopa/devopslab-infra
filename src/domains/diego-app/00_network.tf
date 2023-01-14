# data "azurerm_dns_zone" "public" {
#   name                = join(".", [var.env, var.dns_zone_prefix, var.external_domain])
#   resource_group_name = local.vnet_core_resource_group_name
# }
