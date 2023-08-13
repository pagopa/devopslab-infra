# #
# # zabbix_server
# #
# resource "azurerm_container_app" "zabbix_server" {
#   name                         = "zabbix-server"
#   container_app_environment_id = azurerm_container_app_environment.diego_caenv[0].id
#   resource_group_name          = azurerm_resource_group.container_app_diego.name
#   revision_mode                = "Single"

#   template {
#     min_replicas = 1
#     max_replicas = 1

#     container {
#       name   = "zabbix-server"
#       image  = "zabbix/zabbix-server-pgsql:6.4.5-alpine"
#       cpu    = 0.5
#       memory = "1Gi"

#       env {
#         name  = "DB_SERVER_HOST"
#         value = "dvopla-d-neu-diego-zabbix-pgflex.postgres.database.azure.com"
#       }
#       env {
#         name  = "DB_SERVER_PORT"
#         value = "5432"
#       }
#       env {
#         name  = "POSTGRES_DB"
#         value = "zabbix"
#       }
#       env {
#         name  = "POSTGRES_USER"
#         value = "zabbix"
#       }
#       env {
#         name  = "POSTGRES_PASSWORD"
#         value = "73!5080+"
#       }
#     }

#     container {
#       name   = "zabbix-web-nginx"
#       image  = "zabbix/zabbix-web-nginx-pgsql:6.4.5-alpine"
#       cpu    = 0.5
#       memory = "1Gi"

#       env {
#         name  = "DB_SERVER_HOST"
#         value = "dvopla-d-neu-diego-zabbix-pgflex.postgres.database.azure.com"
#       }
#       env {
#         name  = "DB_SERVER_PORT"
#         value = "5432"
#       }
#       env {
#         name  = "POSTGRES_DB"
#         value = "zabbix"
#       }
#       env {
#         name  = "POSTGRES_USER"
#         value = "zabbix"
#       }
#       env {
#         name  = "POSTGRES_PASSWORD"
#         value = "xxx"
#       }
#       env {
#         name  = "ZBX_SERVER_HOST"
#         value = "xyz.northeurope.azurecontainerapps.io"
#       }
#       env {
#         name  = "ZBX_SERVER_PORT"
#         value = "10051"
#       }
#       env {
#         name  = "PHP_TZ"
#         value = "Europe/Rome"
#       }

#       # liveness_probe {
#       #   failure_count_threshold = 10
#       #   initial_delay           = 10
#       #   interval_seconds        = 10
#       #   path                    = "/status"
#       #   port                    = 8000
#       #   transport               = "HTTP"
#       # }

#       # readiness_probe {
#       #   failure_count_threshold = 10
#       #   interval_seconds        = 10
#       #   path                    = "/status"
#       #   port                    = 8000
#       #   transport               = "HTTP"
#       # }
#     }
#   }

#   ingress {
#     external_enabled = false
#     transport        = "http"
#     target_port      = 8080
#     traffic_weight {
#       latest_revision = true
#       percentage      = 100
#     }
#   }

#   depends_on = [
#     azurerm_container_app_environment.diego_caenv
#   ]
# }

# #
# # zabbix_web_nginx
# #
# resource "azurerm_container_app" "zabbix_web_nginx" {
#   name                         = "zabbix-web-nginx"
#   container_app_environment_id = azurerm_container_app_environment.diego_caenv[0].id
#   resource_group_name          = azurerm_resource_group.container_app_diego.name
#   revision_mode                = "Single"

#   template {
#     min_replicas = 1
#     max_replicas = 1

#     container {
#       name   = "zabbix-web-nginx"
#       image  = "zabbix/zabbix-web-nginx-pgsql:6.4.5-alpine"
#       cpu    = 0.5
#       memory = "1Gi"

#       env {
#         name  = "DB_SERVER_HOST"
#         value = "dvopla-d-neu-diego-zabbix-pgflex.postgres.database.azure.com"
#       }
#       env {
#         name  = "DB_SERVER_PORT"
#         value = "5432"
#       }
#       env {
#         name  = "POSTGRES_DB"
#         value = "zabbix"
#       }
#       env {
#         name  = "POSTGRES_USER"
#         value = "zabbix"
#       }
#       env {
#         name  = "POSTGRES_PASSWORD"
#         value = "xyz"
#       }
#       env {
#         name  = "ZBX_SERVER_HOST"
#         value = "xyz.northeurope.azurecontainerapps.io"
#       }
#       env {
#         name  = "ZBX_SERVER_PORT"
#         value = "10051"
#       }
#       env {
#         name  = "PHP_TZ"
#         value = "Europe/Rome"
#       }

#       # liveness_probe {
#       #   failure_count_threshold = 10
#       #   initial_delay           = 10
#       #   interval_seconds        = 10
#       #   path                    = "/status"
#       #   port                    = 8000
#       #   transport               = "HTTP"
#       # }

#       # readiness_probe {
#       #   failure_count_threshold = 10
#       #   interval_seconds        = 10
#       #   path                    = "/status"
#       #   port                    = 8000
#       #   transport               = "HTTP"
#       # }
#     }
#   }

#   ingress {
#     external_enabled = true
#     target_port      = 8080
#     traffic_weight {
#       latest_revision = true
#       percentage      = 100
#     }
#   }

#   depends_on = [
#     azurerm_container_app_environment.diego_caenv
#   ]
# }
