locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  ingress_hostname_prefix               = "${var.instance}.${var.domain}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  domain_aks_hostname = "${var.instance}.${var.domain}.internal.devopslab.pagopa.it"

  # ACR DOCKER
  docker_rg_name       = "${local.product}-dockerreg-rg"
  docker_registry_name = replace("${var.prefix}-${var.env_short}-${var.location_short}-acr", "-", "")

  aks_name                = var.aks_name
  aks_resource_group_name = var.aks_resource_group_name

  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  # DOMAINS
  domain_namespace        = kubernetes_namespace.domain_namespace.metadata[0].name
  system_domain_namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name

  aks_api_url = var.env_short == "d" ? data.azurerm_kubernetes_cluster.aks.fqdn : data.azurerm_kubernetes_cluster.aks.private_fqdn

  #
  # KeyVault
  #
  key_vault_domain_name           = "dvopla-d-diego-kv"
  key_vault_domain_resource_group = "dvopla-d-diego-sec-rg"

  # Service account
  azure_devops_app_service_account_name        = "azure-devops"
  azure_devops_app_service_account_secret_name = "${local.azure_devops_app_service_account_name}-token"

  #
  # Container App
  #
  container_app_diego_environment_name           = "dvopla-d-diego-cappenv"
  container_app_diego_environment_resource_group = "dvopla-d-diego-container-app-rg"

  container_app_devops_java_springboot_color_name           = "devops-color-java-capp"
  container_app_devops_java_springboot_color_revision_id    = "v1"
  container_app_devops_java_springboot_color_yaml_file_name = "/tmp/${local.container_app_devops_java_springboot_color_revision_id}-${local.container_app_devops_java_springboot_color_name}.yaml"

  container_app_devops_ambassador_name           = "ambassador-capp"
  container_app_devops_ambassador_revision_id    = "v3"
  container_app_devops_ambassador_yaml_file_name = "/tmp/${local.container_app_devops_java_springboot_color_revision_id}-${local.container_app_devops_ambassador_name}.yaml"
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

variable "terraform_remote_state_core" {
  type = object({
    resource_group_name  = string,
    storage_account_name = string,
    container_name       = string,
    key                  = string
  })
}

variable "event_hub_port" {
  type    = number
  default = 9093
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
# VNET
#
variable "cidr_subnet_container_apps" {
  type        = list(string)
  description = "Subnet for container apps in diego domain"
}

variable "cidr_subnet_zabbix_server" {
  type        = list(string)
  description = "Subnet for zabbix vm"
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
