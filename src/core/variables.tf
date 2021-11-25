# general

variable "prefix" {
  type    = string
  default = "usrreg"
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) <= 1
    )
    error_message = "Max length is 1 chars."
  }
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "lock_enable" {
  type        = bool
  default     = false
  description = "Apply locks to block accedentaly deletions."
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

#
# 🔐 Key Vault
#
variable "key_vault_name" {
  type        = string
  description = "Key Vault name"
  default     = ""
}

variable "key_vault_rg_name" {
  type        = string
  default     = ""
  description = "Key Vault - rg name"
}

# ☁️ network
variable "cidr_vnet" {
  type        = list(string)
  description = "Virtual network address space."
}

## Appgateway: Network
variable "cidr_subnet_appgateway" {
  type        = list(string)
  description = "Application gateway address space."
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}

variable "cidr_subnet_postgres" {
  type        = list(string)
  description = "Database network address space."
}

variable "cidr_subnet_apim" {
  type        = list(string)
  description = "Address prefixes subnet api management."
  default     = null
}

variable "cidr_subnet_k8s" {
  type        = list(string)
  description = "Subnet cluster kubernetes."
}

#
# 📇 dns
#
variable "dns_default_ttl_sec" {
  type        = number
  description = "value"
  default     = 3600
}

variable "external_domain" {
  type        = string
  default     = null
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

# ❇️ api gateway
variable "app_gateway_sku_name" {
  type        = string
  description = "SKU Name of the App GW"
  default     = "Standard_v2"
}

variable "app_gateway_sku_tier" {
  type        = string
  description = "SKU tier of the App GW"
  default     = "Standard_v2"
}

variable "app_gateway_alerts_enabled" {
  type        = bool
  description = "Enable alerts"
  default     = false
}

variable "app_gateway_waf_enabled" {
  type        = bool
  description = "Enable WAF"
  default     = false
}
## appgateway: Scaling

variable "app_gateway_min_capacity" {
  type    = number
  default = 0
}

variable "app_gateway_max_capacity" {
  type    = number
  default = 2
}

variable "app_gateway_api_certificate_name" {
  type        = string
  description = "Application gateway api certificate name on Key Vault"
}

# 🚀 azure devops
variable "azdo_sp_tls_cert_enabled" {
  type        = string
  description = "Enable Azure DevOps connection for TLS cert management"
  default     = false
}

variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "enable_iac_pipeline" {
  type        = bool
  description = "If true create the key vault policy to allow used by azure devops iac pipelines."
  default     = false
}

# 🗄 Database server postgresl
variable "postgres_sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server."
}

variable "postgres_public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable/Disable public network access"
}

variable "postgres_geo_redundant_backup_enabled" {
  type        = bool
  default     = false
  description = "Turn Geo-redundant server backups on/off."
}

variable "postgres_enable_replica" {
  type        = bool
  default     = false
  description = "Create a PostgreSQL Server Replica."
}

variable "postgres_storage_mb" {
  type        = number
  description = "Max storage allowed for a server"
  default     = 5120
}

variable "postgres_configuration" {
  type        = map(string)
  description = "PostgreSQL Server configuration"
  default     = {}
}

variable "postgres_alerts_enabled" {
  type        = bool
  default     = false
  description = "Database alerts enabled?"
}

variable "postgres_network_rules" {
  type = object({
    ip_rules                       = list(string)
    allow_access_to_azure_services = bool
  })
  default = {
    ip_rules = []
    # dblink
    allow_access_to_azure_services = true
  }
  description = "Database network rules"
}

variable "postgres_replica_network_rules" {
  type = object({
    ip_rules                       = list(string)
    allow_access_to_azure_services = bool
  })
  default = {
    ip_rules = []
    # dblink
    allow_access_to_azure_services = true
  }
  description = "Database network rules"
}

variable "postgres_metric_alerts" {
  description = <<EOD
Map of name = criteria objects, see these docs for options
https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported#microsoftdbforpostgresqlservers
https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits#maximum-connections
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]
    operator  = string
    threshold = number
    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H
    frequency = string
    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.
    window_size = string

    dimension = list(object(
      {
        name     = string
        operator = string
        values   = list(string)
      }
    ))
  }))

  default = {
    cpu = {
      aggregation = "Average"
      metric_name = "cpu_percent"
      operator    = "GreaterThan"
      threshold   = 70
      frequency   = "PT1M"
      window_size = "PT5M"
      dimension   = []
    }
    memory = {
      aggregation = "Average"
      metric_name = "memory_percent"
      operator    = "GreaterThan"
      threshold   = 75
      frequency   = "PT1M"
      window_size = "PT5M"
      dimension   = []
    }
    io = {
      aggregation = "Average"
      metric_name = "io_consumption_percent"
      operator    = "GreaterThan"
      threshold   = 55
      frequency   = "PT1M"
      window_size = "PT5M"
      dimension   = []
    }
    # https://docs.microsoft.com/it-it/azure/postgresql/concepts-limits
    # GP_Gen5_2 -| 145 / 100 * 80 = 116
    # GP_Gen5_32 -| 1495 / 100 * 80 = 1196
    max_active_connections = {
      aggregation = "Average"
      metric_name = "active_connections"
      operator    = "GreaterThan"
      threshold   = 1196
      frequency   = "PT5M"
      window_size = "PT5M"
      dimension   = []
    }
    min_active_connections = {
      aggregation = "Average"
      metric_name = "active_connections"
      operator    = "LessThanOrEqual"
      threshold   = 0
      frequency   = "PT5M"
      window_size = "PT15M"
      dimension   = []
    }
    failed_connections = {
      aggregation = "Total"
      metric_name = "connections_failed"
      operator    = "GreaterThan"
      threshold   = 10
      frequency   = "PT5M"
      window_size = "PT15M"
      dimension   = []
    }
    replica_lag = {
      aggregation = "Average"
      metric_name = "pg_replica_log_delay_in_seconds"
      operator    = "GreaterThan"
      threshold   = 60
      frequency   = "PT1M"
      window_size = "PT5M"
      dimension   = []
    }
  }
}

#
# 🗺 APIM
#

variable "apim_publisher_name" {
  type = string
  default = ""
  description = "Apim publisher name"
}

variable "apim_sku" {
  type = string
  default = "Developer_1"
  description = "APIM SKU type"
}

variable "apim_api_internal_certificate_name" {
  type        = string
  description = "KeyVault certificate name"
}

#
# ⛴ AKS 
#
variable "aks_private_cluster_enabled" {
  type        = bool
  description = "Enable or not public visibility of AKS"
  default     = false
}

variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

variable "aks_availability_zones" {
  type        = list(number)
  description = "A list of Availability Zones across which the Node Pool should be spread."
  default     = []
}

variable "aks_vm_size" {
  type        = string
  default     = "Standard_DS3_v2"
  description = "The size of the AKS Virtual Machine in the Node Pool."
}

variable "aks_max_pods" {
  type        = number
  description = "The maximum number of pods"
  default     = 100
}

variable "aks_enable_auto_scaling" {
  type        = bool
  description = "Should the Kubernetes Auto Scaler be enabled for this Node Pool? "
  default     = false
}

variable "aks_node_count" {
  type        = number
  description = "The initial number of the AKS nodes which should exist in this Node Pool."
  default     = 1
}

variable "aks_node_min_count" {
  type        = number
  description = "The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000"
  default     = null
}

variable "aks_node_max_count" {
  type        = number
  description = "The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000"
  default     = null
}

variable "kubernetes_version" {
  type    = string
  default = "1.21.2"
}

variable "aks_sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster."
  default     = "Free"
}

variable "reverse_proxy_ip" {
  type        = string
  default     = "127.0.0.1"
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}

variable "aks_metric_alerts" {
  description = <<EOD
Map of name = criteria objects
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    # "Insights.Container/pods" "Insights.Container/nodes"
    metric_namespace = string
    metric_name      = string
    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]
    operator  = string
    threshold = number
    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H
    frequency = string
    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.
    window_size = string

    dimension = list(object(
      {
        name     = string
        operator = string
        values   = list(string)
      }
    ))
  }))

  default = {
    node_cpu = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/nodes"
      metric_name      = "cpuUsagePercentage"
      operator         = "GreaterThan"
      threshold        = 80
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "host"
          operator = "Include"
          values   = ["*"]
        }
      ],
    }
    node_memory = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/nodes"
      metric_name      = "memoryWorkingSetPercentage"
      operator         = "GreaterThan"
      threshold        = 80
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "host"
          operator = "Include"
          values   = ["*"]
        }
      ],
    }
    node_disk = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/nodes"
      metric_name      = "DiskUsedPercentage"
      operator         = "GreaterThan"
      threshold        = 80
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "host"
          operator = "Include"
          values   = ["*"]
        },
        {
          name     = "device"
          operator = "Include"
          values   = ["*"]
        }
      ],
    }
    node_not_ready = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/nodes"
      metric_name      = "nodesCount"
      operator         = "GreaterThan"
      threshold        = 0
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "status"
          operator = "Include"
          values   = ["NotReady"]
        }
      ],
    }
    pods_failed = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/pods"
      metric_name      = "podCount"
      operator         = "GreaterThan"
      threshold        = 0
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "phase"
          operator = "Include"
          values   = ["Failed"]
        }
      ]
    }
    pods_ready = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/pods"
      metric_name      = "PodReadyPercentage"
      operator         = "LessThan"
      threshold        = 80
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "kubernetes namespace"
          operator = "Include"
          values   = ["*"]
        },
        {
          name     = "controllerName"
          operator = "Include"
          values   = ["*"]
        }
      ]
    }
    container_cpu = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/containers"
      metric_name      = "cpuExceededPercentage"
      operator         = "GreaterThan"
      threshold        = 95
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "kubernetes namespace"
          operator = "Include"
          values   = ["*"]
        },
        {
          name     = "controllerName"
          operator = "Include"
          values   = ["*"]
        }
      ]
    }
    container_memory = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/containers"
      metric_name      = "memoryWorkingSetExceededPercentage"
      operator         = "GreaterThan"
      threshold        = 95
      frequency        = "PT1M"
      window_size      = "PT5M"
      dimension = [
        {
          name     = "kubernetes namespace"
          operator = "Include"
          values   = ["*"]
        },
        {
          name     = "controllerName"
          operator = "Include"
          values   = ["*"]
        }
      ]
    }
    container_oom = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/pods"
      metric_name      = "oomKilledContainerCount"
      operator         = "GreaterThan"
      threshold        = 0
      frequency        = "PT1M"
      window_size      = "PT1M"
      dimension = [
        {
          name     = "kubernetes namespace"
          operator = "Include"
          values   = ["*"]
        },
        {
          name     = "controllerName"
          operator = "Include"
          values   = ["*"]
        }
      ]
    }
    container_restart = {
      aggregation      = "Average"
      metric_namespace = "Insights.Container/pods"
      metric_name      = "restartingContainerCount"
      operator         = "GreaterThan"
      threshold        = 0
      frequency        = "PT1M"
      window_size      = "PT1M"
      dimension = [
        {
          name     = "kubernetes namespace"
          operator = "Include"
          values   = ["*"]
        },
        {
          name     = "controllerName"
          operator = "Include"
          values   = ["*"]
        }
      ]
    }
  }
}

variable "aks_alerts_enabled" {
  type        = bool
  default     = true
  description = "Aks alert enabled?"
}

#
# Locals
#
locals {
  monitor_rg = format("%s-monitor-rg", local.project)
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  # api.internal.*.userregistry.pagopa.it
  api_internal_domain = format("api.internal.%s.%s", var.dns_zone_prefix, var.external_domain)
}
