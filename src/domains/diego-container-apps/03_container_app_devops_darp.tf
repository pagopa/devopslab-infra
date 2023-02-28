# locals {
#   container_app_devops_java_springboot_color_yaml_content = templatefile("${path.module}/container-app/devops-java-springboot-color.yaml.tpl", {
#     REVISION_ID                            = local.container_app_devops_java_springboot_color_revision_id,
#     DVOPLA-D-APPINSIGHTS-CONNECTION-STRING = module.domain_key_vault_secrets_query.values["dvopla-d-appinsights-connection-string"].value,
#     CONTAINER_APP_NAME                     = local.container_app_devops_java_springboot_color_name,
#     CONTAINER_APP_RESOURCE_GROUP           = local.container_app_diego_environment_resource_group,
#     CONTAINER_APP_ENVIRONMENT_NAME         = local.container_app_diego_environment_name,
#   })
# }

data "azurerm_container_app_environment" "dapr_env" {
  name                = local.container_app_dapr_environment_name
  resource_group_name = azurerm_resource_group.container_app_diego.name

  depends_on = [
    null_resource.container_app_dapr_create_env
  ]
}

#
# Frontend
#
resource "azurerm_container_app" "frontend" {
  name                         = "frontend-dapr-showcase"
  container_app_environment_id = data.azurerm_container_app_environment.dapr_env.id
  resource_group_name          = azurerm_resource_group.container_app_diego.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "frontend"
      image  = "ghcr.io/pagopa/devops-webapp-python:beta-colors"
      cpu    = 0.5
      memory = "1Gi"

      liveness_probe {
        failure_count_threshold = 10
        initial_delay           = 10
        interval_seconds        = 10
        path                    = "/status"
        port                    = 8000
        transport               = "HTTP"
      }

      readiness_probe {
        failure_count_threshold = 10
        interval_seconds        = 10
        path                    = "/status"
        port                    = 8000
        transport               = "HTTP"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  dapr {
    app_id   = "frontend"
    app_port = 8000
  }

  depends_on = [
    data.azurerm_container_app_environment.dapr_env
  ]
}

#
# backend
#
resource "azurerm_container_app" "backend" {
  name                         = "backend-dapr-showcase"
  container_app_environment_id = data.azurerm_container_app_environment.dapr_env.id
  resource_group_name          = azurerm_resource_group.container_app_diego.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "backend"
      image  = "ghcr.io/diegoitaliait/dapr-showcase:beta-enable-dapr"
      cpu    = 0.5
      memory = "1Gi"

      liveness_probe {
        failure_count_threshold = 10
        initial_delay           = 10
        interval_seconds        = 10
        path                    = "/status"
        port                    = 3000
        transport               = "HTTP"
      }

      readiness_probe {
        failure_count_threshold = 10
        interval_seconds        = 10
        path                    = "/status"
        port                    = 3000
        transport               = "HTTP"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  dapr {
    app_id   = "backend"
    app_port = 3000
  }

  depends_on = [
    data.azurerm_container_app_environment.dapr_env
  ]
}
