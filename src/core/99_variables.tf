# general

locals {
  project = "${var.prefix}-${var.env_short}"

  # VNET
  vnet_resource_group_name = "${local.project}-vnet-rg"
  vnet_name                = "${local.project}-vnet"

  # VNET Ephemeral
  vnet_ephemeral_resource_group_name = "${local.project}-ephemeral-vnet-rg"
  vnet_ephemeral_name                = "${local.project}-ephemeral-vnet"

  appgateway_public_ip_name      = "${local.project}-gw-pip"
  appgateway_beta_public_ip_name = "${local.project}-gw-beta-pip"

  #APIM
  # api.internal.*.devopslab.pagopa.it
  api_internal_domain            = "api.internal.${var.prod_dns_zone_prefix}.${var.external_domain}"
  apim_management_public_ip_name = "${local.project}-apim-management-pip"

  #AKS
  aks_public_ip_name           = "${local.project}-aksoutbound-pip"
  aks_ephemeral_public_ip_name = "${local.project}-aks-ephemeral-outbound-pip"

  prod_dns_zone_public_name = "${var.prod_dns_zone_prefix}.${var.external_domain}"
  lab_dns_zone_public_name  = "${var.lab_dns_zone_prefix}.${var.external_domain}"
  dns_zone_private_name     = "internal.${var.prod_dns_zone_prefix}.${var.external_domain}"
  dns_zone_lab_private_name = "internal.${var.lab_dns_zone_prefix}.${var.external_domain}"

  # ACR DOCKER
  docker_rg_name       = "${local.project}-dockerreg-rg"
  docker_registry_name = replace("${var.prefix}-${var.env_short}-${var.location_short}-acr", "-", "")

  # monitor
  monitor_rg_name                      = "${local.project}-monitor-rg"
  monitor_log_analytics_workspace_name = "${local.project}-law"
  monitor_appinsights_name             = "${local.project}-appinsights"
  monitor_security_storage_name        = replace("${local.project}-sec-monitor-st", "-", "")

  # Azure DevOps
  azuredevops_rg_name       = "${local.project}-azdoa-rg"
  azuredevops_agent_vm_name = "${local.project}-vmss-ubuntu-azdoa"
  azuredevops_subnet_name   = "${local.project}-azdoa-snet"
}

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

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "location_short" {
  type        = string
  description = "Location short like eg: neu, weu.."
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

variable "cidr_subnet_private_endpoints" {
  type        = list(string)
  description = "Subnet cidr postgres flex."
}

variable "cidr_subnet_vpn" {
  type        = list(string)
  description = "VPN network address space."
}

variable "cidr_subnet_dnsforwarder" {
  type        = list(string)
  description = "DNS Forwarder network address space."
}

variable "cidr_subnet_redis" {
  type        = list(string)
  description = "Redis."
}

variable "cidr_subnet_apim" {
  type        = list(string)
  description = "Address prefixes subnet api management."
  default     = null
}

variable "cidr_subnet_apim_stv2" {
  type        = list(string)
  description = "Address prefixes subnet api management stv2."
  default     = null
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

variable "postgres_private_endpoint_enabled" {
  type        = bool
  description = "Enable vnet private endpoint for postgres"
}

variable "postgres_public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Enable/Disable public network access"
}

variable "postgres_network_rules" {
  type = object({
    ip_rules                       = list(string)
    allow_access_to_azure_services = bool
  })
  default = {
    ip_rules                       = []
    allow_access_to_azure_services = false
  }
  description = "Database network rules"
}

variable "postgres_alerts_enabled" {
  type        = bool
  default     = false
  description = "Database alerts enabled?"
}

variable "postgres_byok_enabled" {
  type        = bool
  default     = false
  description = "Enable postgresql encryption with Customer Managed Key (BYOK)"
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

#
# ⛴ AKS
#
variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

variable "aks_ephemeral_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS prod cluster"
}

#
# VPN
#
variable "vpn_enabled" {
  type        = bool
  description = "Enable VPN setup"
  default     = false
}

variable "dns_forwarder_enabled" {
  type        = bool
  description = "Enable dns forwarder setup"
  default     = false
}

## VPN ##
variable "vpn_sku" {
  type        = string
  default     = "VpnGw1"
  description = "VPN Gateway SKU"
}

variable "vpn_pip_sku" {
  type        = string
  default     = "Basic"
  description = "VPN GW PIP SKU"
}

#
# Redis
#
variable "redis_enabled" {
  type    = bool
  default = false
}


variable "azdoa_image_name" {
  type        = string
  description = "Azure DevOps Agent image name"
}

#
# Feature flags
#
variable "is_resource_core_enabled" {
  type = object({
    postgresql_server = bool,
  })
}

#
# 🗺 APIM
#

variable "apim_publisher_name" {
  type        = string
  default     = ""
  description = "Apim publisher name"
}

variable "apim_sku" {
  type        = string
  description = "APIM SKU type"
}

variable "apim_api_internal_certificate_name" {
  type        = string
  description = "KeyVault certificate name"
}

variable "apim_subnet_nsg_security_rules" {
  type        = list(any)
  description = "Network security rules for APIM subnet"
}

variable "apim_enabled" {
  type = bool
}
