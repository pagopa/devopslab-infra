data "azurerm_virtual_network" "vnet_ita" {
  name                = local.vnet_ita_core_name
  resource_group_name = local.vnet_ita_core_rg_name
}

data "azurerm_resource_group" "rg_vnet_ita" {
  name = local.vnet_ita_core_rg_name
}

data "azurerm_subnet" "packer_azdo_subnet" {
  name                 = local.subnet_packer_azdo_name
  virtual_network_name = local.vnet_ita_core_name
  resource_group_name  = local.vnet_ita_core_rg_name
}

data "azurerm_subnet" "packer_dns_subnet" {
  name                 = local.subnet_packer_dnsforwarder_name
  virtual_network_name = local.vnet_ita_core_name
  resource_group_name  = local.vnet_ita_core_rg_name
}
