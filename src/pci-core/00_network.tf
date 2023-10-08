resource "azurerm_private_dns_zone" "storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_blob_azure_com_vnet" {
  name                  = module.vnet_data.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = module.vnet_data.id
  registration_enabled  = false

  tags = var.tags
}

# Cosmos MongoDB  - private dns zone

resource "azurerm_private_dns_zone" "privatelink_mongo_cosmos_azure_com" {

  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_privatelink_mongo_cosmos_azure_com" {

  name                  = module.vnet_data.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_mongo_cosmos_azure_com.name
  virtual_network_id    = module.vnet_data.id
  registration_enabled  = false

  tags = var.tags
}

# DNS private: internal.dev.platform.pagopa.it

resource "azurerm_private_dns_zone" "internal_pci_pagopa_it" {
  name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "internal_pci_vnetlink_vnet_core" {
  name                  = module.vnet_app.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.internal_pci_pagopa_it.name
  virtual_network_id    = module.vnet_app.id
  registration_enabled  = false

  tags = var.tags
}

# DNS key vault

resource "azurerm_private_dns_zone" "key_vault_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_keyvault_azure_com_vnet" {
  name                  = module.vnet_data.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault_dns.name
  virtual_network_id    = module.vnet_data.id
  registration_enabled  = false

  tags = var.tags
}

module "route_table_aks" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//route_table?ref=v5.5.2"

  name                          = "${local.project}-all2firewall-rt"
  location                      = azurerm_resource_group.rg_vnet.location
  resource_group_name           = azurerm_resource_group.rg_vnet.name
  disable_bgp_route_propagation = false

  subnet_ids = []

  routes = [
    {
      # dev aks nodo oncloud
      name                   = "all-route-to-firewall-subnet"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.99.99.4"
    },
  ]

  tags = var.tags
}

# link all Private DNS in subscription tu HUB transit VNET
# N.B resources indexed by dns name. N.B.2 resource group is not present in azurerm_resourse, so got it from splitting id at 4^ position

data "azurerm_resources" "sub_resources" {
  type = "Microsoft.Network/privateDnsZones"
}

resource "azurerm_private_dns_zone_virtual_network_link" "all_to_vnet_hub" {
  for_each              = { for i, v in data.azurerm_resources.sub_resources.resources : data.azurerm_resources.sub_resources.resources[i].name => v }
  name                  = module.vnet_hub.name
  resource_group_name   = split("/", each.value["id"])[4]
  private_dns_zone_name = each.value["name"]
  virtual_network_id    = module.vnet_hub.id
  registration_enabled  = false

  tags = var.tags
}

# Flexible PostgreSql DNS private 
resource "azurerm_private_dns_zone" "privatelink_postgres_database_azure_com" {

  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink_postgres_database_azure_com_vnet" {

  name                  = "${local.project}-data-vnet"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_postgres_database_azure_com.name
  virtual_network_id    = module.vnet_data.id
  registration_enabled  = false

  tags = var.tags
}

## Application gateway public ip ##
resource "azurerm_public_ip" "appgateway_public_ip" {
  name                = format("%s-appgateway-pip", local.project)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  // availability_zone   = var.app_gateway_public_ip_availability_zone
  zones = [1, 2, 3]

  tags = var.tags
}