# general

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
  validation {
    condition = (
      length(var.env) <= 4
    )
    error_message = "Max length is 4 chars."
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

variable "location_dr" {
  type    = string
  default = "northeurope"
}

variable "location_short_dr" {
  type        = string
  description = "Location short like eg: neu, weu.."
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
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

variable "cidr_frontend_vnet" {
  type        = list(string)
  description = "Address prefixes vnet frontend"
  default     = null
}

variable "cidr_application_vnet" {
  type        = list(string)
  description = "Address prefixes vnet application"
  default     = null
}

variable "cidr_data_vnet" {
  type        = list(string)
  description = "Address prefixes vnet database"
  default     = null
}

variable "cidr_hub_vnet" {
  type        = list(string)
  description = "Address prefixes vnet hub"
  default     = null
}

variable "cidr_firewall_subnet" {
  type        = list(string)
  description = "Address prefixes subnet firewall"
  default     = null
}

variable "cidr_firewall_mng_subnet" {
  type        = list(string)
  description = "Address prefixes subnet management firewall"
  default     = null
}

variable "cidr_azdoa_subnet" {
  type        = list(string)
  description = "Address prefixes subnet azdoa"
  default     = null
}

variable "cidr_vpn_subnet" {
  type        = list(string)
  description = "Address prefixes subnet vpn"
  default     = null
}

variable "cidr_subnet_dns_forwarder" {
  type        = list(string)
  description = "Address prefixes subnet vpn forwarder"
  default     = null
}

variable "cidr_subnet_vdi" {
  type = list(string)
}

variable "enable_region_dr" {
  description = "If set to true, enable region dr"
  type        = bool
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

variable "dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "dns_default_ttl_sec" {
  type        = number
  description = "value"
  default     = 3600
}

variable "pci_availability_zones" {
  type        = list(string)
  default     = ["1"]
  description = "List of zones"
}

variable "firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  type = list(object({
    name        = string
    description = optional(string)
    action      = string
    rules = list(object({
      policyname            = string
      source_addresses      = optional(list(string))
      destination_ports     = list(string)
      destination_addresses = optional(list(string))
      destination_fqdns     = optional(list(string))
      protocols             = list(string)
    }))
  }))
  default = []
}

variable "firewall_application_rules" {
  description = "Microsoft-managed virtual network that enables connectivity from other resources."
  type = list(object({
    name        = string
    description = optional(string)
    action      = string
    rules = list(object({
      policyname       = string
      source_addresses = optional(list(string))
      source_ip_groups = optional(list(string))
      fqdn_tags        = optional(list(string))
      target_fqdns     = optional(list(string))
      protocol = optional(object({
        type = string
        port = string
      }))
    }))
  }))
  default = []
}

variable "firewall_application_rules_tags" {
  description = "Microsoft-managed virtual network that enables connectivity from other resources."
  type = list(object({
    name        = string
    description = optional(string)
    action      = string
    rules = list(object({
      policyname       = string
      source_addresses = optional(list(string))
      source_ip_groups = optional(list(string))
      fqdn_tags        = optional(list(string))
      target_fqdns     = optional(list(string))
    }))
  }))
  default = []
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

variable "cidr_subnet_apim" {
  type        = list(string)
  description = "Address prefixes subnet api management."
  default     = null
}

variable "cidr_subnet_appgateway" {
  type        = list(string)
  description = "Address prefixes subnet appgateway."
  default     = null
}
