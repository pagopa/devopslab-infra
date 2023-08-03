resource "azurerm_resource_group" "eventhub_rg" {
  name     = "${local.project}-eventhub-rg"
  location = var.location

  tags = var.tags
}

## Eventhub subnet
module "eventhub_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.3.1"
  name                                      = "${local.project}-eventhub-snet"
  address_prefixes                          = var.cidr_subnet_eventhub
  resource_group_name                       = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = data.azurerm_virtual_network.vnet.name
  service_endpoints                         = ["Microsoft.EventHub"]
  private_endpoint_network_policies_enabled = true
}


module "event_hub" {
  count = var.is_resource_coreplus_enabled.eventhub ? 1 : 0
  source                   = "git::https://github.com/pagopa/terraform-azurerm-v3.git//eventhub?ref=v6.3.1"
  name                     = "${local.project}-evh-ns"
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
