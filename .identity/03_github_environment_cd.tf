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

resource "github_actions_environment_secret" "github_environment_cd_secrets" {
  for_each        = local.cd_secrets
  repository      = var.github.repository
  environment     = local.github_cd_env_name
  secret_name     = each.key
  plaintext_value = each.value
}

