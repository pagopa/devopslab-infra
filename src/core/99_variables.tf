# general

locals {
  project     = "${var.prefix}-${var.env_short}"
  project_neu = "${var.prefix}-${var.env_short}-${var.location_short}"
  project_ita = "${var.prefix}-${var.env_short}-${var.location_short_ita}"

  # VNET
  vnet_resource_group_name = "${local.project}-vnet-rg"
  vnet_name                = "${local.project}-vnet"

  vnet_ita_resource_group_name = "${local.project_ita}-vnet-rg"
  vnet_ita_name                = "${local.project_ita}-vnet"

  appgateway_public_ip_name      = "${local.project}-gw-pip"
  appgateway_beta_public_ip_name = "${local.project}-gw-beta-pip"

  #APIM
  # api.internal.*.devopslab.pagopa.it
  api_internal_domain              = "api.${var.dns_zone_internal_prefix}.${var.external_domain}"
  apim_management_public_ip_name   = "${local.project}-apim-management-pip"
  apim_management_public_ip_name_2 = "${local.project}-apim-management-v2-pip"

  #AKS
  aks_public_ip_name           = "${local.project}-aksoutbound-pip"
  aks_ephemeral_public_ip_name = "${local.project}-aks-ephemeral-outbound-pip"

  prod_dns_zone_public_name = "${var.dns_zone_prefix}.${var.external_domain}"
  dns_zone_private_name     = "${var.dns_zone_internal_prefix}.${var.external_domain}"

  # ACR DOCKER
  docker_rg_name       = "${local.project}-docker-registry-rg"
  docker_registry_name = replace("${var.prefix}-${var.env_short}-${var.location_short_ita}-acr", "-", "")

  # monitor
  monitor_rg_name                      = "${local.project}-monitor-rg"
  monitor_log_analytics_workspace_name = "${local.project}-law"
  monitor_appinsights_name             = "${local.project}-appinsights"
  monitor_security_storage_name        = replace("${local.project}-sec-monitor-st", "-", "")


  # monitor
  monitor_ita_rg_name                      = "${local.project_ita}-monitor-rg"
  monitor_ita_log_analytics_workspace_name = "${local.project_ita}-law"
  monitor_ita_appinsights_name             = "${local.project_ita}-appinsights"
  monitor_ita_security_storage_name        = replace("${local.project_ita}-sec-monitor-st", "-", "")

  # Azure DevOps
  azuredevops_rg_name       = "${local.project_ita}-azdoa-rg"
  azuredevops_agent_vm_name = "${local.project_ita}-vmss-ubuntu-azdoa"
  azuredevops_subnet_name   = "${local.project_ita}-azdoa-snet"
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

variable "location_ita" {
  type        = string
  description = "Main location"
}

variable "location_short_ita" {
  type = string
  validation {
    condition = (
      length(var.location_short_ita) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "Location short for italy: itn"
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

variable "cidr_subnet_packer_azdo" {
  type        = list(string)
  description = "VPN network address space."
}

variable "cidr_subnet_packer_dns_forwarder" {
  type        = list(string)
  description = "VPN network address space."
}

variable "cidr_subnet_dnsforwarder_lb" {
  type        = list(string)
  description = "DNS Forwarder network address space for LB."
}

variable "cidr_subnet_dnsforwarder_vmss" {
  type        = list(string)
  description = "DNS Forwarder network address space for VMSS."
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

variable "cidr_subnet_tools_cae" {
  type = list(string)
}

variable "dns_zone_prefix" {
  type = string
}

## Ita

variable "cidr_vnet_italy" {
  type        = list(string)
  description = "Address prefixes for vnet in italy."
}

### Italy location
variable "vnet_ita_ddos_protection_plan" {
  type = object({
    id     = string
    enable = bool
  })
  default = null
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

variable "dns_zone_internal_prefix" {
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
  description = "VPN Gateway SKU"
}

variable "vpn_pip_sku" {
  type        = string
  description = "VPN GW PIP SKU"
}

variable "dns_forwarder_vmss_image_name" {
  type        = string
  description = "vpn dns forwarder image name"
}

#
# Redis
#
variable "redis_enabled" {
  type    = bool
  default = false
}


variable "azdoa_image_version" {
  type        = string
  description = "Azure DevOps Agent image version"
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

#
# dns forwarder
#
variable "dns_forwarder_is_enabled" {
  type        = bool
  default     = true
  description = "Allow to enable or disable dns forwarder backup"
}

#
# Container app env
#
variable "container_app_tools_cae_env_rg" {
  type = string
}
