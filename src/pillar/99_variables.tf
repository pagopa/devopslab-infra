# general

variable "prefix" {
  type    = string
  default = "dvopla"
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
  validation {
    condition = (
      length(var.env) <= 3
    )
    error_message = "Max length is 3 chars."
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

# ☁️ network
variable "cidr_vnet" {
  type        = list(string)
  description = "Virtual network address space."
}

variable "cidr_subnet_postgres" {
  type        = list(string)
  description = "Database network address space."
}

# 🧵 dns
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

variable "prod_dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "lab_dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}

variable "enable_iac_pipeline" {
  type        = bool
  description = "If true create the key vault policy to allow used by azure devops iac pipelines."
  default     = false
}

## 🔭 Monitor
variable "law_sku" {
  type        = string
  description = "Sku of the Log Analytics Workspace"
  default     = "PerGB2018"
}

variable "law_retention_in_days" {
  type        = number
  description = "The workspace data retention in days"
  default     = 30
}

variable "law_daily_quota_gb" {
  type        = number
  description = "The workspace daily quota for ingestion in GB."
  default     = -1
}

# # 🗄 Database server postgres
# variable "postgres_sku_name" {
#   type        = string
#   description = "Specifies the SKU Name for this PostgreSQL Server."
# }

# variable "postgres_private_endpoint_enabled" {
#   type        = bool
#   description = "Enable vnet private endpoint for postgres"
# }

# variable "postgres_public_network_access_enabled" {
#   type        = bool
#   default     = false
#   description = "Enable/Disable public network access"
# }

# variable "postgres_network_rules" {
#   type = object({
#     ip_rules                       = list(string)
#     allow_access_to_azure_services = bool
#   })
#   default = {
#     ip_rules                       = []
#     allow_access_to_azure_services = false
#   }
#   description = "Database network rules"
# }

# variable "postgres_geo_redundant_backup_enabled" {
#   type        = bool
#   default     = false
#   description = "Turn Geo-redundant server backups on/off."
# }

# variable "postgres_alerts_enabled" {
#   type        = bool
#   default     = false
#   description = "Database alerts enabled?"
# }

# variable "postgres_byok_enabled" {
#   type        = bool
#   default     = false
#   description = "Enable postgresql encryption with Customer Managed Key (BYOK)"
# }

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

#
# ⛴ AKS
#
variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

locals {
  project = "${var.prefix}-${var.env}"
  vnet_resource_group = "rg-vnet-${local.project}"
  vnet_name = "vnet-${local.project}"

  appgateway_public_ip_name = "pip-agw-${local.project}"
  aks_public_ip_name = "pip-aksoutbound-${local.project}"

  prod_dns_zone_public_name = "${var.prod_dns_zone_prefix}.${var.external_domain}"
  lab_dns_zone_public_name = "${var.lab_dns_zone_prefix}.${var.external_domain}"
  dns_zone_private_name = "internal.${var.lab_dns_zone_prefix}.${var.external_domain}"

  # ACR DOCKER
  docker_rg_name = "rg-docker-${var.env}"
  docker_registry_name = replace("acr-${var.prefix}-${var.env}", "-", "")

  # MONITORING
  monitoring_rg_name = "rg-monitor-${var.env}"
  monitoring_analytics_workspace_name = "law-${local.project}"
  monitoring_appinsights_name = "appinsights-${local.project}"
}
