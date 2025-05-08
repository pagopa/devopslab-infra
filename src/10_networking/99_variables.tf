# general

locals {
  project     = "${var.prefix}-${var.env_short}"

  # VNET
  vnet_resource_group_name = "${local.project}-vnet-rg"
  vnet_name                = "${local.project}-vnet"

  vnet_ita_resource_group_name = "${local.project}-vnet-rg"
  vnet_ita_name                = "${local.project}-vnet"

  appgateway_public_ip_name      = "${local.project}-gw-pip"
  appgateway_beta_public_ip_name = "${local.project}-gw-beta-pip"

  prod_dns_zone_public_name = "${var.dns_zone_prefix}.${var.external_domain}"
  dns_zone_private_name     = "${var.dns_zone_internal_prefix}.${var.external_domain}"
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
}

variable "location_short" {
  type        = string
  description = "Location short like eg: itn.."
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
variable "cidr_subnet_vpn" {
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
  description = "Domain for delegation"
}

variable "dns_zone_internal_prefix" {
  type        = string
  description = "The dns subdomain."
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

variable "dns_forwarder_vmss_image_version" {
  type        = string
  description = "vpn dns forwarder image version"
}

#
# dns forwarder
#
variable "dns_forwarder_is_enabled" {
  type        = bool
  default     = true
  description = "Allow to enable or disable dns forwarder backup"
}
