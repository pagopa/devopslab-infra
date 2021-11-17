resource "azurerm_resource_group" "rg_app" {
  name     = format("%s-app-rg", local.project)
  location = var.location
  tags     = var.tags
}

#
# 📦 ACR
#
module "acr" {
  source              = "git::https://github.com/pagopa/azurerm.git//container_registry?ref=v1.0.84"
  name                = replace(format("%s-acr", local.project), "-", "")
  resource_group_name = azurerm_resource_group.rg_app.name
  location            = azurerm_resource_group.rg_app.location
  
  #https://docs.microsoft.com/en-us/azure/app-service/faq-app-service-linux#multi-container-with-docker-compose
  admin_enabled       = true

  tags = var.tags
}

#
# 🚀 APP Service container
#
module "app_container" {
  source = "git::https://github.com/pagopa/azurerm.git//app_service?ref=v1.0.84"

  name                = format("%s-app", local.project)
  location           = azurerm_resource_group.rg_app.location
  plan_name           = format("%s-plan-app", local.project)
  resource_group_name = azurerm_resource_group.rg_app.name
  plan_kind           = "Linux"

  plan_sku_tier     = var.app_service_sku.tier
  plan_sku_size     = var.app_service_sku.size
  plan_sku_capacity = var.app_service_sku.capacity
  plan_reserved     = true

  health_check_path = "/healt"

  app_settings = {

    # DB_NAME     = var.database_name
    # DB_USER     = format("%s@%s", data.azurerm_key_vault_secret.db_administrator_login.value, azurerm_mysql_server.mysql_server.fqdn)
    # DB_PASSWORD = data.azurerm_key_vault_secret.db_administrator_login_password.value
    # DB_HOST     = azurerm_mysql_server.mysql_server.fqdn

    # MICROSOFT_AZURE_ACCOUNT_KEY            = module.storage_account.primary_access_key
    # MICROSOFT_AZURE_ACCOUNT_NAME           = module.storage_account.name
    # MICROSOFT_AZURE_CONTAINER              = "media"
    # MICROSOFT_AZURE_USE_FOR_DEFAULT_UPLOAD = true

    # https://github.com/terraform-providers/terraform-provider-azurerm/issues/5073#issuecomment-564296263
    # in terraform app service needs log block instead WEBSITE_HTTPLOGGING_RETENTION_DAYS
    # WEBSITE_HTTPLOGGING_RETENTION_DAYS  = 7
    # WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    DOCKER_REGISTRY_SERVER_URL      = "https://${module.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = module.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = module.acr.admin_password
  }

  linux_fx_version = "DOCKER|mcr.microsoft.com/appsvc/staticsite:latest"

  always_on = "true"

  # subnet_name = module.subnet_cms_outbound.name
  # subnet_id   = module.subnet_cms_outbound.id

  tags = var.tags
}
