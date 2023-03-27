locals {
  project  = "${var.prefix}-${var.env_short}"
  app_name = "github-${var.github.org}-${var.github.repository}-${var.env}"

  #
  # Storage state
  #
  tfstate_storage_account_name    = "dvopladstinfraterraform"
  tfstate_storage_account_rg_name = "io-infra-rg"

  #
  # Container app
  #
  container_app_github_runner_env_name = "dvopla-d-neu-core-github-runner-cae"
  container_app_github_runner_env_rg   = "dvopla-d-neu-core-github-runner-rg"

  # CD
  github_cd_env_name = "${var.env}-cd"

  cd_secrets = {
    "AZURE_TENANT_ID" : data.azurerm_client_config.current.tenant_id,
    "AZURE_SUBSCRIPTION_ID" : data.azurerm_subscription.current.subscription_id,
    "AZURE_CLIENT_ID" : module.github_runner_cd.client_id,
    "AZURE_CONTAINER_APP_ENVIRONMENT_NAME" : local.container_app_github_runner_env_name,
    "AZURE_RESOURCE_GROUP_NAME" : local.container_app_github_runner_env_rg,
  }

  # CI
  github_ci_env_name = "${var.env}-ci"
  ci_secrets = {
    "AZURE_TENANT_ID" : data.azurerm_client_config.current.tenant_id,
    "AZURE_SUBSCRIPTION_ID" : data.azurerm_subscription.current.subscription_id,
    "AZURE_CLIENT_ID" : module.github_runner_ci.client_id,
    "AZURE_CONTAINER_APP_ENVIRONMENT_NAME" : local.container_app_github_runner_env_name,
    "AZURE_RESOURCE_GROUP_NAME" : local.container_app_github_runner_env_rg,
  }

  # RUNNER
  github_runner_env_name = "${var.env}-runner"
  runner_secrets = {
    "AZURE_TENANT_ID" : data.azurerm_client_config.current.tenant_id,
    "AZURE_SUBSCRIPTION_ID" : data.azurerm_subscription.current.subscription_id,
    "AZURE_CLIENT_ID" : module.github_runner_creator.client_id,
    "AZURE_CONTAINER_APP_ENVIRONMENT_NAME" : local.container_app_github_runner_env_name,
    "AZURE_RESOURCE_GROUP_NAME" : local.container_app_github_runner_env_rg,
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
  type        = string
  description = "Environment"
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

variable "github" {
  type = object({
    org        = string
    repository = string
  })
  description = "GitHub Organization and repository name"
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub Organization and repository name"
}

variable "environment_ci_roles" {
  type = object({
    subscription = list(string)
  })
  description = "GitHub Continous Integration roles"
}

variable "github_repository_environment_ci" {
  type = object({
    protected_branches     = bool
    custom_branch_policies = bool
  })
  description = "GitHub Continous Integration roles"
}

variable "environment_cd_roles" {
  type = object({
    subscription = list(string)
  })
  description = "GitHub Continous Delivery roles"
}

variable "github_repository_environment_cd" {
  type = object({
    protected_branches     = bool
    custom_branch_policies = bool
    reviewers_teams        = list(string)
  })
  description = "GitHub Continous Integration roles"
}
