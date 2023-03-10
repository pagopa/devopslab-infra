resource "github_repository_environment" "github_repository_environment_cd" {
  environment = "${var.env}-cd"
  repository  = var.github.repository
  # filter teams reviewers from github_organization_teams
  # if reviewers_teams is null no reviewers will be configured for environment
  dynamic "reviewers" {
    for_each = (var.github_repository_environment_cd.reviewers_teams == null ? [] : [1])
    content {
      teams = matchkeys(
        data.github_organization_teams.all.teams.*.id,
        data.github_organization_teams.all.teams.*.name,
        var.github_repository_environment_cd.reviewers_teams
      )
    }
  }
  deployment_branch_policy {
    protected_branches     = var.github_repository_environment_cd.protected_branches
    custom_branch_policies = var.github_repository_environment_cd.custom_branch_policies
  }
}

module "github_environment_cd_secrets" {
  source = "./modules/github-environment-secrets"

  github_repository                  = "devopslab-infra"
  github_repository_environment_name = "${var.env}-cd"

  secrets = {
    "AZURE_TENANT_ID" : data.azurerm_client_config.current.tenant_id,
    "AZURE_SUBSCRIPTION_ID" : data.azurerm_subscription.current.subscription_id,
    "AZURE_CLIENT_ID" : module.github_runner_cd.client_id,
    "AZURE_CONTAINER_APP_ENVIRONMENT_NAME" : local.container_app_github_runner_env_name,
    "AZURE_RESOURCE_GROUP_NAME" : local.container_app_github_runner_env_rg,
  }
}
