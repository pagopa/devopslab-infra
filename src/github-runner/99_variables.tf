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

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "location_short" {
  type    = string
  default = "neu"
  validation {
    condition     = length(var.location_short) <= 3
    error_message = "The length of the 'location_short' variable must not exceed 3 characters."
  }
}


variable "key_vault_common" {
  type = object({
    name            = string
    pat_secret_name = string
  })
}

variable "networking" {
  type = object({
    vnet_common_name  = string
    subnet_cidr_block = string
  })
}

variable "law_name" {
  type    = string
  default = "Log Analytics Workspace name"
}
