locals {

  test_urls = [
    {
      # management.env.cstar.pagopa.it
      host                 = "google.com",
      path                 = "/",
      expected_http_status = 200
    },
  ]

}

module "web_test_availability_alert_rules_for_api" {
  for_each = { for v in local.test_urls : v.host => v if v != null }
  source   = "git::https://github.com/pagopa/azurerm.git//application_insights_web_test_preview?ref=v2.8.2"

  subscription_id                   = data.azurerm_subscription.current.subscription_id
  name                              = "${each.value.host}-test-avail"
  location                          = azurerm_resource_group.monitor_rg.location
  resource_group                    = azurerm_resource_group.monitor_rg.name
  application_insight_name          = azurerm_application_insights.application_insights.name
  request_url                       = "https://${each.value.host}${each.value.path}"
  ssl_cert_remaining_lifetime_check = 7
  expected_http_status              = each.value.expected_http_status

  actions = [
    {
      action_group_id = azurerm_monitor_action_group.email.id,
    },
    {
      action_group_id = azurerm_monitor_action_group.slack.id,
    },
  ]
}
