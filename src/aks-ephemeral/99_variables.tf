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

variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

#
# Locals
#
locals {
  project = "${var.prefix}-${var.env_short}"

  # VNET
  vnet_ephemeral_resource_group_name = "${local.project}-ephemeral-vnet-rg"
  vnet_ephemeral_name                = "${local.project}-ephemeral-vnet"

  # ACR DOCKER
  docker_rg_name       = "${local.project}-dockerreg-rg"
  docker_registry_name = replace("${var.prefix}-${var.env_short}-${var.location_short}-acr", "-", "")

  # AKS
  aks_ephemeral_rg_name              = "${local.project}-ephemeral-aks-rg"
  aks_ephemeral_cluster_name         = "${local.project}-ephemeral-aks"
  aks_ephemeral_public_ip_name       = "${local.project}-aks-ephemeral-outbound-pip"
  aks_ephemeral_public_ip_index_name = "${local.aks_public_ip_name}-${var.aks_num_outbound_ips}"

  # monitor
  monitor_rg_name                      = "${local.project}-monitor-rg"
  monitor_log_analytics_workspace_name = "${local.project}-law"
  monitor_appinsights_name             = "${local.project}-appinsights"
  monitor_security_storage_name        = replace("${local.project}-sec-monitor-st", "-", "")

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"
}
