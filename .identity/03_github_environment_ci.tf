resource "github_repository_environment" "github_repository_environment_ci" {
  environment = "${var.env}-ci"
  repository  = var.github.repository
  deployment_branch_policy {
    protected_branches     = var.github_repository_environment_ci.protected_branches
    custom_branch_policies = var.github_repository_environment_ci.custom_branch_policies
  }
}

resource "github_actions_environment_secret" "github_environment_ci_secrets" {
  for_each        = local.ci_secrets

  repository      = var.github.repository
  environment     = local.github_ci_env_name
  secret_name     = each.key
  plaintext_value = each.value

  depends_on = [
    github_repository_environment.github_repository_environment_ci
  ]
}
