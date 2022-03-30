resource "azurerm_resource_group" "grafana_rg" {
  name     = "${local.project}-grafana-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_storage_account" "grafana_storage" {
  name                     = "${var.prefix}${var.env}grafanadatast"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.grafana_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_share" "grafana_volume" {
  name                 = "appservice-volume"
  storage_account_name = azurerm_storage_account.grafana_storage.name
  quota                = 50

  lifecycle {
    prevent_destroy = true
  }
}

module "grafana_service" {
  depends_on = [azurerm_storage_share_file.grafana_db]

  source = "git::https://github.com/pagopa/azurerm.git//app_service?ref=v2.8.0"

  name                = "${local.project}-grafana-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.grafana_rg.name

  plan_type     = "internal"
  plan_name     = "${local.project}-grafana-plan"
  plan_kind     = "Linux"
  plan_sku_tier = "Basic"
  plan_sku_size = "B2"
  plan_reserved = true

  always_on         = true
  linux_fx_version  = "DOCKER|grafana/grafana-oss:latest"
  health_check_path = "/api/health"

  app_settings = {
    WEBSITES_PORT                     = 3000
    GF_AZURE_MANAGED_IDENTITY_ENABLED = true
  }

  storage_mounts = [{
    name         = "gf_data_path"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.grafana_storage.name
    share_name   = azurerm_storage_share.grafana_volume.name
    access_key   = azurerm_storage_account.grafana_storage.primary_access_key
    mount_path   = "/var/lib/grafana"
  }]

  tags = var.tags
}

resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = module.grafana_service.principal_id
}

# Look at ./grafana_db/README.md
resource "azurerm_storage_share_file" "grafana_db" {
  name             = "grafana.db"
  source           = "grafana_db/grafana.db"
  storage_share_id = azurerm_storage_share.grafana_volume.id

  lifecycle {
    prevent_destroy = true
  }
}
