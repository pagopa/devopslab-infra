resource "azurerm_resource_group" "app_service_docker_rg" {
  name     = "${local.program}-app-service-docker-rg"
  location = var.location

  tags = var.tags
}

# Subnet to host the api config
module "app_service_docker_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v3.15.0"
  name                 = "${local.program}-app-docker-snet"
  address_prefixes     = var.cidr_subnet_app_docker
  virtual_network_name = data.azurerm_virtual_network.vnet.name

  resource_group_name = data.azurerm_resource_group.rg_vnet.name

  private_endpoint_network_policies_enabled = true
  service_endpoints                         = ["Microsoft.Web"]
}

locals {
  apiconfig_cors_configuration = {
    origins = ["*"]
    methods = ["*"]
  }
}

resource "azurerm_app_service_plan" "app_docker" {

  count = var.is_web_app_service_docker_enabled ? 1 : 0

  name                = "${local.program}-plan-app-service-docker"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_service_docker_rg.name

  kind = "Linux"

  sku {
    tier = "Basic"
    size = "B1"
  }
  reserved = true

  tags = var.tags
}

module "web_app_service_docker" {
  count = var.is_web_app_service_docker_enabled ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//app_service?ref=v3.15.0"

  resource_group_name = azurerm_resource_group.app_service_docker_rg.name
  location            = var.location

  plan_type = "external"
  plan_id   = azurerm_app_service_plan.app_docker[0].id

  # App service plan
  name                = "${local.program}-app-service-docker"
  client_cert_enabled = false
  always_on           = false
  linux_fx_version    = "DOCKER|${data.azurerm_container_registry.acr.login_server}/devopswebapppython:latest"
  health_check_path   = "/status"

  app_settings = {
    # Monitoring
    APPINSIGHTS_INSTRUMENTATIONKEY                  = data.azurerm_application_insights.application_insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING           = "InstrumentationKey=${data.azurerm_application_insights.application_insights.instrumentation_key}"
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
    APPLICATIONINSIGHTS_CONFIGURATION_CONTENT       = ""
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~3"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
    WEBSITE_HEALTHCHECK_MAXPINGFAILURES             = 10
    TIMEOUT_DELAY                                   = 300
    # Integration with private DNS (see more: https://docs.microsoft.com/en-us/answers/questions/85359/azure-app-service-unable-to-resolve-hostname-of-vi.html)
    WEBSITE_DNS_SERVER = "168.63.129.16"
    # Spring Environment

    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    WEBSITES_PORT                       = 8000
    # DOCKER_REGISTRY_SERVER_URL      = "https://${module.acr[0].login_server}"
    # DOCKER_REGISTRY_SERVER_USERNAME = module.acr[0].admin_username
    # DOCKER_REGISTRY_SERVER_PASSWORD = module.acr[0].admin_password
  }

  allowed_subnets = [module.apim_snet.id]
  allowed_ips     = []

  subnet_id = module.app_service_docker_snet.id

  tags = var.tags
}

#
# Role assignments
#
resource "azurerm_role_assignment" "webapp_docker_to_acr" {
  count = var.is_web_app_service_docker_enabled ? 1 : 0

  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.web_app_service_docker[0].principal_id
}
