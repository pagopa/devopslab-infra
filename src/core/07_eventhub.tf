resource "azurerm_resource_group" "eventhub_rg" {
  name     = format("%s-eventhub-rg", local.project)
  location = var.location

  tags = var.tags
}

## Eventhub subnet
module "eventhub_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=version-unlocked"
  name                                           = format("%s-eventhub-snet", local.project)
  address_prefixes                               = var.cidr_subnet_eventhub
  resource_group_name                            = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = data.azurerm_virtual_network.vnet.name
  service_endpoints                              = ["Microsoft.EventHub"]
  enforce_private_link_endpoint_network_policies = true
}


module "event_hub" {
  source                   = "git::https://github.com/pagopa/azurerm.git//eventhub?ref=version-unlocked"
  name                     = format("%s-evh-ns", local.project)
  location                 = var.location
  resource_group_name      = azurerm_resource_group.eventhub_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units
  zone_redundant           = var.ehns_zone_redundant

  virtual_network_ids = [data.azurerm_virtual_network.vnet.id]
  subnet_id           = module.eventhub_snet.id

  eventhubs = var.eventhubs

  alerts_enabled = false
  # metric_alerts  = var.ehns_metric_alerts
  action = [
    {
      action_group_id    = data.azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = data.azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]

  tags = var.tags
}
