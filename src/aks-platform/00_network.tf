#
# Core
#

data "azurerm_resource_group" "vnet_core_rg" {
  name = local.vnet_core_resource_group_name
}

data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = data.azurerm_resource_group.vnet_core_rg.name
}

#
# Vnet AKS
#
data "azurerm_resource_group" "vnet_italy_rg" {
  name = var.rg_vnet_italy_name
}

data "azurerm_virtual_network" "vnet_italy" {
  name                = var.vnet_italy_name
  resource_group_name = data.azurerm_resource_group.vnet_italy_rg.name
}

#
# Pip
#
data "azurerm_public_ip" "pip_aks_outboud" {
  name                = var.public_ip_aksoutbound_name
  resource_group_name = data.azurerm_resource_group.vnet_italy_rg.name
}

#
# Subnet
#
# data "azurerm_subnet" "private_endpoint_subnet" {
#   name                 = "${local.product}-private-endpoints-snet"
#   resource_group_name  = data.azurerm_resource_group.vnet_core_rg.name
#   virtual_network_name = data.azurerm_virtual_network.vnet_core.name
# }

# data "azurerm_subnet" "private_endpoint_italy_subnet" {
#   name                 = "${local.product}-private-endpoints-italy-snet"
#   resource_group_name  = data.azurerm_resource_group.vnet_italy_rg.name
#   virtual_network_name = data.azurerm_virtual_network.vnet_italy.name
# }

#
# Dns
#
data "azurerm_private_dns_zone" "storage_account_private_dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.vnet_italy_rg.name
}

data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}
