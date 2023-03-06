locals {
  environment_ci_roles = {
    subscription = [
      "Reader",
      "Reader and Data Access",
      "Storage Blob Data Reader",
      "Storage File Data SMB Share Reader",
      "Storage Queue Data Reader",
      "Storage Table Data Reader",
      "PagoPA Export Deployments Template",
      "Key Vault Secrets User",
      "DocumentDB Account Contributor",
      "API Management Service Contributor",
    ]
  }
}

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "app_name" {
  type        = string
  description = "App name (SP)"
}

variable "github_org" {
  type        = string
  description = "GitHub Organization"
}

variable "github_repository" {
  type        = string
  description = "GitHub Repository"
}

variable "iac_aad_group_name" {
  type        = string
  description = "Azure AD group name for iac sp apps (with Directory Reader permissions at leats)"
}

variable "subscription_id" {
  type        = string
  description = "Suscription ID"
}

variable "tfstate_storage_account_name" {
  type        = string
  description = "Storage name where the tf state is saved"
}

variable "tfstate_storage_account_rg_name" {
  type        = string
  description = "Resopurce group of storage name where the tf state is saved"
}

variable "custom_role_name" {
  type        = string
  description = "Custom role that allows IaC SP to read resources and generate kubernetes credentials"
  default     = "PagoPA IaC Reader"
}
