locals {
  product     = "${var.prefix}-${var.env_short}"
  product_ita = "${var.prefix}-${var.env_short}-${var.location_short}"
  project     = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  monitor_appinsights_name        = "${local.product_ita}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  ingress_hostname_prefix               = "${var.domain}.${var.location_short}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product_ita}-vnet-rg"

  domain_aks_hostname = "${var.domain}.${var.location_short}.internal.devopslab.pagopa.it"

  aks_name                = var.aks_name
  aks_resource_group_name = var.aks_resource_group_name

  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  #   # DOMAINS
  #   domain_namespace        = kubernetes_namespace.domain_namespace.metadata[0].name
  #   system_domain_namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name

  aks_api_url = data.azurerm_kubernetes_cluster.aks.private_fqdn

  #
  # KeyVault
  #
  key_vault_domain_name           = "dvopla-d-itn-testit-kv"
  key_vault_domain_resource_group = "dvopla-d-itn-testit-sec-rg"

  # Service account
  azure_devops_app_service_account_name        = "azure-devops"
  azure_devops_app_service_account_secret_name = "${local.azure_devops_app_service_account_name}-token"

}

variable "is_feature_enabled" {
  type = object({
    nodepool_dedicated = bool
  })
  default = {
    nodepool_dedicated = false
  }
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

#
# Network
#
variable "rg_vnet_italy_name" {
  type        = string
  description = "Resource group dedicated to VNet AKS"
}

variable "vnet_italy_name" {
  type        = string
  description = "VNet dedicated to AKS"
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

### Aks
variable "cidr_subnet_user_aks_testit" {
  type        = list(string)
  description = "Subnet cluster kubernetes."
}

variable "aks_name" {
  type        = string
  description = "AKS cluster name"
}

variable "aks_resource_group_name" {
  type        = string
  description = "AKS cluster resource name"

}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "ingress_load_balancer_hostname" {
  type    = string
  default = ""
}

# DNS
variable "external_domain" {
  type        = string
  default     = "pagopa.it"
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  description = "The dns subdomain."
}

variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

#
# Tls Checker
#
variable "tls_cert_check_helm" {
  type = object({
    chart_version = string,
    image_name    = string,
    image_tag     = string
  })
  description = "tls cert helm chart configuration"
}

#
# NodePool
#
variable "aks_user_node_pool_testit" {
  type = object({
    name                       = string,
    vm_size                    = string,
    os_disk_type               = string,
    os_disk_size_gb            = string,
    node_count_min             = number,
    node_count_max             = number,
    node_labels                = map(any),
    node_taints                = list(string),
    node_tags                  = map(any),
    ultra_ssd_enabled          = optional(bool, false),
    enable_host_encryption     = optional(bool, true),
    max_pods                   = optional(number, 250),
    upgrade_settings_max_surge = optional(string, "30%"),
    zones                      = optional(list(any), [1, 2, 3]),
  })
  description = "AKS node pool user configuration"
}


variable "event_hub_port" {
  type    = number
  default = 9093
}
