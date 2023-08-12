data "azurerm_container_app_environment" "diego_env" {
  name                = local.container_app_diego_environment_name
  resource_group_name = azurerm_resource_group.container_app_diego.name

  depends_on = [
    null_resource.container_app_dapr_create_env
  ]
}

#
# zabbix_web_nginx
#
resource "azurerm_container_app" "zabbix_web_nginx" {
  name                         = "zabbix_web_nginx"
  container_app_environment_id = data.azurerm_container_app_environment.diego_env.id
  resource_group_name          = azurerm_resource_group.container_app_diego.name
  revision_mode                = "Single"

  template {
    min_replicas = 0
    max_replicas = 1

    container {
      name   = "zabbix_web_nginx"
      image  = "zabbix/zabbix-web-nginx-pgsql:6.4.5-alpine"
      cpu    = 0.5
      memory = "1Gi"

      # liveness_probe {
      #   failure_count_threshold = 10
      #   initial_delay           = 10
      #   interval_seconds        = 10
      #   path                    = "/status"
      #   port                    = 8000
      #   transport               = "HTTP"
      # }

      # readiness_probe {
      #   failure_count_threshold = 10
      #   interval_seconds        = 10
      #   path                    = "/status"
      #   port                    = 8000
      #   transport               = "HTTP"
      # }
    }
  }

  ingress {
    external_enabled = false
    target_port      = 8000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  dapr {
    app_id   = "zabbix_web_nginx"
    app_port = 8000
  }

  depends_on = [
    data.azurerm_container_app_environment.diego_env
  ]
}

#
# zabbix_server
#
resource "azurerm_container_app" "zabbix_server" {
  name                         = "zabbix_server"
  container_app_environment_id = data.azurerm_container_app_environment.diego_env.id
  resource_group_name          = azurerm_resource_group.container_app_diego.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "zabbix_server"
      image  = "zabbix/zabbix-server-pgsql:6.4.5-alpine"
      cpu    = 0.5
      memory = "1Gi"

    #   liveness_probe {
    #     failure_count_threshold = 10
    #     initial_delay           = 10
    #     interval_seconds        = 10
    #     path                    = "/status"
    #     port                    = 3000
    #     transport               = "HTTP"
    #   }

    #   readiness_probe {
    #     failure_count_threshold = 10
    #     interval_seconds        = 10
    #     path                    = "/status"
    #     port                    = 3000
    #     transport               = "HTTP"
    #   }
    # }
  }

  ingress {
    external_enabled = false
    target_port      = 3000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  dapr {
    app_id   = "zabbix_server"
    app_port = 3000
  }

  depends_on = [
    data.azurerm_container_app_environment.diego_env
  ]
}
