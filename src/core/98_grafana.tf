resource "azurerm_resource_group" "grafana_rg" {
  name     = "${local.project}-grafana-rg"
  location = var.location

  tags = var.tags
}

module "grafana_app_docker" {
  source = "git::https://github.com/pagopa/azurerm.git//app_service?ref=v2.2.0"

  name                = "${local.project}-grafana"
  location            = var.location
  resource_group_name = azurerm_resource_group.grafana_rg.name

  plan_type     = "internal"
  plan_name     = "${local.project}-grafana-plan"
  plan_kind     = "Linux"
  plan_sku_tier = "Basic"
  plan_sku_size = "B1"
  plan_reserved = true

  always_on         = true
  linux_fx_version  = "DOCKER|grafana/grafana-oss:latest"
  health_check_path = "/api/health"

  app_settings = {
    #APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insights.application_insights.instrumentation_key
    #APPLICATIONINSIGHTS_CONNECTION_STRING           = "InstrumentationKey=${azurerm_application_insights.application_insights.instrumentation_key}"
    WEBSITES_PORT                                   = 3000
  }

  tags = var.tags
}

# module "grafana_app_registration" {
#   source = "git::https://github.com/pagopa/azuread-tf-modules.git//reader_application"

#   application_name = "${local.project}-grafana"
#   secret_description = "Grafana client"
# }
