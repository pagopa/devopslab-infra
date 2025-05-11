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
  type = string
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

variable "cidr_subnet_packer_dns_forwarder" {
  type        = list(string)
  description = "VPN network address space."
}

variable "cidr_subnet_dnsforwarder_vmss" {
  type        = list(string)
  description = "DNS Forwarder network address space for VMSS."
}

variable "cidr_subnet_dnsforwarder_lb" {
  type        = list(string)
  description = "DNS Forwarder network address space for LB."
}

variable "cidr_subnet_packer_azdo" {
  type        = list(string)
  description = "packer azdo network address space."
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


#
# dns forwarder
#
variable "dns_forwarder_vmss_image_version" {
  type        = string
  description = "vpn dns forwarder image version"
}
