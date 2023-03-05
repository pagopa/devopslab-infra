resource "github_repository_environment" "github_repository_environment_ci" {
  environment = "${var.env}-ci"
  repository  = var.github.repository
  deployment_branch_policy {
    protected_branches     = var.github_repository_environment_ci.protected_branches
    custom_branch_policies = var.github_repository_environment_ci.custom_branch_policies
  }
}

module "github_environment_ci_secrets" {
  source = "./modules/github-environment-secrets"

  github_repository                  = "devopslab-infra"
  github_repository_environment_name = "${var.env}-ci"

  secrets = {
    "AZURE_TENANT_ID" : data.azurerm_client_config.current.tenant_id,
    "AZURE_SUBSCRIPTION_ID" : data.azurerm_subscription.current.subscription_id,
    "AZURE_CLIENT_ID" : module.github_runner_ci.client_id
    "AZURE_CONTAINER_APP_ENVIRONMENT_NAME" : local.container_app_github_runner_env_name,
    "AZURE_RESOURCE_GROUP_NAME" : local.container_app_github_runner_env_rg
  }
}
