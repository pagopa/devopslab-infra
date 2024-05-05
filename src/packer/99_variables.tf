# general

locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}"

  vnet_ita_core_name    = "dvopla-d-itn-vnet"
  vnet_ita_core_rg_name = "dvopla-d-itn-vnet-rg"

  azdo_resource_group_name = "dvopla-d-itn-azdoa-rg"

  subnet_packer_azdo_name         = "packer-azdo-subnet"
  subnet_packer_dnsforwarder_name = "packer-dns-forwarder-subnet"

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

variable "location" {
  type    = string
  default = "westeurope"
}

variable "location_short" {
  type        = string
  description = "Location short like eg: neu, weu.."
}

variable "azdo_image_version" {
  type        = string
  description = "Version string to allow to force the creation of the image"
}

variable "dns_forwarder_image_version" {
  type        = string
  description = "Version string to allow to force the creation of the image"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}
