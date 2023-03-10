locals {
  # github_app_roles = {
  #   subscription = [
  #     "Contributor",
  #     "Storage Account Contributor",
  #     "Storage Blob Data Contributor",
  #     "Storage File Data SMB Share Contributor",
  #     "Storage Queue Data Contributor",
  #     "Storage Table Data Contributor",
  #   ]
  # }
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

# variable "iac_aad_group_name" {
#   type        = string
#   description = "Azure AD group name for iac sp apps (with Directory Reader permissions at leats)"
# }

variable "subscription_id" {
  type        = string
  description = "Suscription ID"
}

variable "github_environment_name" {
  type        = string
  description = "Environemnt name created into github, associated to this account sp"
}

variable "container_app_github_runner_env_rg" {
  type        = string
  description = "Resource group where the container app environment is located"
}
