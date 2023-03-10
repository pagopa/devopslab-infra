resource "github_repository_environment" "github_repository_environment_runner" {
  environment = "${var.env}-runner"
  repository  = var.github.repository
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

module "github_environment_runner_secrets" {
  source = "./modules/github-environment-secrets"

  github_repository                  = "devopslab-infra"
  github_repository_environment_name = "${var.env}-runner"

  secrets = {
    "AZURE_TENANT_ID" : data.azurerm_client_config.current.tenant_id,
    "AZURE_SUBSCRIPTION_ID" : data.azurerm_subscription.current.subscription_id,
    "AZURE_CLIENT_ID" : module.github_runner_creator.client_id,
    "AZURE_CONTAINER_APP_ENVIRONMENT_NAME" : local.container_app_github_runner_env_name,
    "AZURE_RESOURCE_GROUP_NAME" : local.container_app_github_runner_env_rg,
  }
}
