#
# APP CONFIGURATION
#

locals {
  function_app = {
    app_settings_common = {
      FUNCTIONS_WORKER_RUNTIME       = "node"
      WEBSITE_NODE_DEFAULT_VERSION   = "14.16.0"
      WEBSITE_RUN_FROM_PACKAGE       = "1"
      WEBSITE_VNET_ROUTE_ALL         = "1"
      WEBSITE_DNS_SERVER             = "168.63.129.16"
      FUNCTIONS_WORKER_PROCESS_COUNT = 4
      NODE_ENV                       = "production"
    }
    app_settings_1 = {
    }
    app_settings_2 = {
    }
  }

  func_python = {
    app_settings_common = local.function_app.app_settings_common
    app_settings_1 = {
    }
    app_settings_2 = {
    }
  }
}

resource "azurerm_resource_group" "func_python_rg" {
  name     = "${local.project}-func-python-rg"
  location = var.location

  tags = var.tags
}

# Subnet to host app function
module "func_python_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=version-unlocked"
  name                                           = "${local.project}-func-python-snet"
  address_prefixes                               = var.cidr_subnet_app_async
  resource_group_name                            = data.azurerm_resource_group.vnet_common_rg.name
  virtual_network_name                           = data.azurerm_virtual_network.vnet_common.name
  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB",
    "Microsoft.Storage",
  ]

  delegation = {
    name = "default"
    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

#tfsec:ignore:azure-storage-queue-services-logging-enabled:exp:2022-05-01 # already ignored, maybe a bug in tfsec
module "func_python" {
  source = "git::https://github.com/pagopa/azurerm.git//function_app?ref=version-unlocked"

  resource_group_name = azurerm_resource_group.func_python_rg.name
  name                = "${local.project}-func-python"
  location            = var.location
  health_check_path   = "/api/v1/info"

  os_type          = "linux"
  linux_fx_version = "NODE|14"
  runtime_version  = "~4"

  always_on                                = "true"
  application_insights_instrumentation_key = data.azurerm_application_insights.application_insights.instrumentation_key

  app_service_plan_info = {
    kind                         = var.function_app_async_kind
    sku_tier                     = var.function_app_async_sku_tier
    sku_size                     = var.function_app_async_sku_size
    maximum_elastic_worker_count = 0
  }

  app_settings = merge(
    local.func_python.app_settings_common, {
      "AzureWebJobs.StoreSpidLogs.Disabled" = "0",
    }
  )

  # internal_storage = {
  #   "enable"                     = true,
  #   "private_endpoint_subnet_id" = data.azurerm_subnet.private_endpoints_subnet.id,
  #   "private_dns_zone_blob_ids"  = [data.azurerm_private_dns_zone.privatelink_blob_core_windows_net.id],
  #   "private_dns_zone_queue_ids" = [data.azurerm_private_dns_zone.privatelink_queue_core_windows_net.id],
  #   "private_dns_zone_table_ids" = [data.azurerm_private_dns_zone.privatelink_table_core_windows_net.id],
  #   "queues"                     = [],
  #   "containers"                 = [],
  #   "blobs_retention_days"       = 1,
  # }

  subnet_id = module.func_python_snet.id

  allowed_subnets = [
    module.func_python_snet.id,
  ]

  tags = var.tags
}

# module "function_app_async_staging_slot" {
#   source = "git::https://github.com/pagopa/azurerm.git//function_app_slot?ref=v3.4.0"

#   name                = "staging"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.func_python_rg.name
#   function_app_name   = module.func_python.name
#   function_app_id     = module.func_python.id
#   app_service_plan_id = module.func_python.app_service_plan_id
#   health_check_path   = "/api/v1/info"

#   storage_account_name               = module.func_python.storage_account.name
#   storage_account_access_key         = module.func_python.storage_account.primary_access_key
#   internal_storage_connection_string = module.func_python.storage_account_internal_function.primary_connection_string

#   os_type                                  = "linux"
#   linux_fx_version                         = "NODE|14"
#   always_on                                = "true"
#   runtime_version                          = "~4"
#   application_insights_instrumentation_key = data.azurerm_application_insights.application_insights.instrumentation_key

#   app_settings = merge(
#     local.func_python.app_settings_common, {
#       "AzureWebJobs.StoreSpidLogs.Disabled" = "1",
#     }
#   )

#   subnet_id = module.func_python_snet.id

#   allowed_subnets = [
#     module.func_python_snet.id,
#     data.azurerm_subnet.azdoa_snet[0].id,
#   ]

#   tags = var.tags
# }

# resource "azurerm_monitor_autoscale_setting" "func_python" {
#   name                = format("%s-autoscale", module.func_python.name)
#   resource_group_name = azurerm_resource_group.func_python_rg.name
#   location            = var.location
#   target_resource_id  = module.func_python.app_service_plan_id

#   profile {
#     name = "default"

#     capacity {
#       default = var.function_app_async_autoscale_default
#       minimum = var.function_app_async_autoscale_minimum
#       maximum = var.function_app_async_autoscale_maximum
#     }

#     rule {
#       metric_trigger {
#         metric_name              = "Requests"
#         metric_resource_id       = module.func_python.id
#         metric_namespace         = "microsoft.web/sites"
#         time_grain               = "PT1M"
#         statistic                = "Average"
#         time_window              = "PT5M"
#         time_aggregation         = "Average"
#         operator                 = "GreaterThan"
#         threshold                = 3000
#         divide_by_instance_count = false
#       }

#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = "2"
#         cooldown  = "PT5M"
#       }
#     }

#     rule {
#       metric_trigger {
#         metric_name              = "CpuPercentage"
#         metric_resource_id       = module.func_python.app_service_plan_id
#         metric_namespace         = "microsoft.web/serverfarms"
#         time_grain               = "PT1M"
#         statistic                = "Average"
#         time_window              = "PT5M"
#         time_aggregation         = "Average"
#         operator                 = "GreaterThan"
#         threshold                = 45
#         divide_by_instance_count = false
#       }

#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = "2"
#         cooldown  = "PT5M"
#       }
#     }

#     rule {
#       metric_trigger {
#         metric_name              = "Requests"
#         metric_resource_id       = module.func_python.id
#         metric_namespace         = "microsoft.web/sites"
#         time_grain               = "PT1M"
#         statistic                = "Average"
#         time_window              = "PT5M"
#         time_aggregation         = "Average"
#         operator                 = "LessThan"
#         threshold                = 2000
#         divide_by_instance_count = false
#       }

#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT20M"
#       }
#     }

#     rule {
#       metric_trigger {
#         metric_name              = "CpuPercentage"
#         metric_resource_id       = module.func_python.app_service_plan_id
#         metric_namespace         = "microsoft.web/serverfarms"
#         time_grain               = "PT1M"
#         statistic                = "Average"
#         time_window              = "PT5M"
#         time_aggregation         = "Average"
#         operator                 = "LessThan"
#         threshold                = 30
#         divide_by_instance_count = false
#       }

#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT20M"
#       }
#     }
#   }
# }

# ## Alerts

# resource "azurerm_monitor_metric_alert" "function_app_async_health_check" {
#   name                = "${module.func_python.name}-health-check-failed"
#   resource_group_name = azurerm_resource_group.func_python_rg.name
#   scopes              = [module.func_python.id]
#   description         = "${module.func_python.name} health check failed"
#   severity            = 1
#   frequency           = "PT5M"
#   auto_mitigate       = false

#   criteria {
#     metric_namespace = "Microsoft.Web/sites"
#     metric_name      = "HealthCheckStatus"
#     aggregation      = "Average"
#     operator         = "LessThan"
#     threshold        = 50
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.email.id
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.slack.id
#   }
# }
