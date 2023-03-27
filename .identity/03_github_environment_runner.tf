resource "github_repository_environment" "github_repository_environment_runner" {
  environment = "${var.env}-runner"
  repository  = var.github.repository
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_actions_environment_secret" "github_environment_runner_secrets" {
  for_each        = local.runner_secrets

  repository      = var.github.repository
  environment     = local.github_runner_env_name
  secret_name     = each.key
  plaintext_value = each.value

  depends_on = [
    github_repository_environment.github_repository_environment_runner
  ]
}
