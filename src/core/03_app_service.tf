resource "azurerm_resource_group" "app_docker_rg" {
  name     = "${local.project}-app-docker-rg"
  location = var.location

  tags = var.tags
}

# Subnet to host the api config
module "app_docker_snet" {
  source                = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.1.21"
  name                  = "${local.project}-app-docker-snet"
  address_prefixes      = var.cidr_subnet_app_docker
  virtual_network_name = data.azurerm_virtual_network.vnet.name

  resource_group_name   = data.azurerm_resource_group.rg_vnet.name

  enforce_private_link_endpoint_network_policies = true   
  service_endpoints                              = ["Microsoft.Web"]
}

locals {
  apiconfig_cors_configuration = {
    origins = ["*"]
    methods = ["*"]
  }
}

resource "azurerm_app_service_plan" "this" {
  name                = "${local.project}-plan-app-docker"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_docker_rg.name

  kind = "Linux"

  sku {
    tier = "Basic"
    size = "B1"
  }

#   maximum_elastic_worker_count = var.plan_maximum_elastic_worker_count
  reserved                     = true
#   per_site_scaling             = var.plan_per_site_scaling

  tags = var.tags
}

# module "web_app_docker" {
#   source = "git::https://github.com/pagopa/azurerm.git//app_service?ref=v1.0.93"

#   resource_group_name = azurerm_resource_group.app_docker_rg.name
#   location            = var.location

#   # App service plan vars
#   plan_name     = 
#   plan_kind     = 
#   plan_sku_tier = var.api_config_tier
#   plan_sku_size = var.api_config_size
#   plan_reserved = true # Mandatory for Linux plan

#   # App service plan
#   name                = format("%s-app-app-docker", local.project)
#   client_cert_enabled = false
#   always_on           = var.api_config_always_on
#   # linux_fx_version    = "JAVA|11-java11"
#   linux_fx_version  = format("DOCKER|%s/api-apiconfig-backend:%s", module.acr[0].login_server, "latest")
#   health_check_path = "/apiconfig/api/v1/info"


#   app_settings = {
#     # Monitoring
#     APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insights.application_insights.instrumentation_key
#     APPLICATIONINSIGHTS_CONNECTION_STRING           = format("InstrumentationKey=%s", azurerm_application_insights.application_insights.instrumentation_key)
#     APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
#     APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
#     APPLICATIONINSIGHTS_CONFIGURATION_CONTENT       = ""
#     ApplicationInsightsAgent_EXTENSION_VERSION      = "~3"
#     DiagnosticServices_EXTENSION_VERSION            = "~3"
#     InstrumentationEngine_EXTENSION_VERSION         = "disabled"
#     SnapshotDebugger_EXTENSION_VERSION              = "disabled"
#     XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
#     XDT_MicrosoftApplicationInsights_Mode           = "recommended"
#     XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
#     WEBSITE_HEALTHCHECK_MAXPINGFAILURES             = 10
#     TIMEOUT_DELAY                                   = 300
#     # Integration with private DNS (see more: https://docs.microsoft.com/en-us/answers/questions/85359/azure-app-service-unable-to-resolve-hostname-of-vi.html)
#     WEBSITE_DNS_SERVER = "168.63.129.16"
#     # Spring Environment
#     SPRING_DATASOURCE_USERNAME = data.azurerm_key_vault_secret.db_nodo_usr.value
#     SPRING_DATASOURCE_PASSWORD = data.azurerm_key_vault_secret.db_nodo_pwd.value
#     SPRING_DATASOURCE_URL      = var.db_service_name == null ? null : format("jdbc:oracle:thin:@%s.%s:%s/%s", azurerm_private_dns_a_record.private_dns_a_record_db_nodo.name, azurerm_private_dns_zone.db_nodo_dns_zone.name, var.db_port, var.db_service_name)
#     CORS_CONFIGURATION         = jsonencode(local.apiconfig_cors_configuration)
#     XSD_ICA                    = var.xsd_ica

#     WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
#     WEBSITES_PORT                       = 8080
#     # WEBSITE_SWAP_WARMUP_PING_PATH       = "/actuator/health"
#     # WEBSITE_SWAP_WARMUP_PING_STATUSES   = "200"
#     DOCKER_REGISTRY_SERVER_URL      = "https://${module.acr[0].login_server}"
#     DOCKER_REGISTRY_SERVER_USERNAME = module.acr[0].admin_username
#     DOCKER_REGISTRY_SERVER_PASSWORD = module.acr[0].admin_password

#   }

#   allowed_subnets = [module.apim_snet.id]
#   allowed_ips     = []

#   subnet_name = module.app_docker_snet[0].name
#   subnet_id   = module.app_docker_snet[0].id

#   tags = var.tags
# }