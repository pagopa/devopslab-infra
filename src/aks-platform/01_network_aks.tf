resource "azurerm_subnet" "system_aks_subnet" {
  name                                          = "${local.project}-system-aks"
  resource_group_name                           = data.azurerm_resource_group.vnet_italy_rg.name
  virtual_network_name                          = data.azurerm_virtual_network.vnet_italy.name
  address_prefixes                              = var.cidr_subnet_system_aks
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet" "user_aks_subnet" {
  name                 = "${local.project}-user-aks"
  resource_group_name  = data.azurerm_resource_group.vnet_italy_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet_italy.name
  address_prefixes     = var.cidr_subnet_user_aks

  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}
