# general
locals {
  project       = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product       = "${var.prefix}-${var.env_short}"
  product_italy = "${var.prefix}-${var.env_short}-${var.location_short}"

  # monitor
  monitor_rg_name                      = "${local.product_italy}-monitor-rg"
  monitor_log_analytics_workspace_name = "${local.product_italy}-law"
  monitor_appinsights_name             = "${local.product_italy}-appinsights"
  monitor_security_storage_name        = replace("${local.product_italy}-sec-monitor-st", "-", "")

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  vnet_core_name                = "${local.product_italy}-vnet"
  vnet_core_resource_group_name = "${local.product_italy}-vnet-rg"

  dns_zone_public_name  = "devopslab.pagopa.it"
  dns_zone_private_name = "internal.devopslab.pagopa.it"

  container_registry_common_name    = "dvopladneuacr"
  rg_container_registry_common_name = "dvopla-d-dockerreg-rg"
}

variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
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
  type        = string
  description = "One of westeurope, northeurope"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
}

variable "instance" {
  type        = string
  description = "One of beta, prod01, prod02"
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

variable "is_feature_enabled" {
  type = object({
    cdn = optional(bool, false)
  })
  description = "Features enabled in this domain"
}

# DNS
variable "external_domain" {
  type        = string
  default     = "pagopa.it"
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  default     = "devopslab"
  description = "The dns subdomain."
}

### External resources

variable "monitor_resource_group_name" {
  type        = string
  description = "Monitor resource group name"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace."
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Log Analytics workspace is located in."
}

#
# AKS
#
variable "aks_resource_group_name" {
  type        = string
  description = "(Required) Resource group of the Kubernetes cluster."
}

variable "aks_name" {
  type        = string
  description = "(Required) Name of the Kubernetes cluster."
}
