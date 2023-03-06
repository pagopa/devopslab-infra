locals {
  github_app_roles = {
    subscription = [
      "Contributor",
      "Storage Account Contributor",
      "Storage Blob Data Contributor",
      "Storage File Data SMB Share Contributor",
      "Storage Queue Data Contributor",
      "Storage Table Data Contributor",
    ]
  }
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

variable "github_environment_name" {
  type        = string
  description = "Environemnt name created into github, associated to this account sp"
}

variable "tfstate_storage_account_name" {
  type        = string
  description = "Storage name where the tf state is saved"
}

variable "tfstate_storage_account_rg_name" {
  type        = string
  description = "Resopurce group of storage name where the tf state is saved"
}
