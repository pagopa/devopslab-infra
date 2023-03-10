module "github_runner_creator" {
  source = "./modules/app-github-runner-creator"

  app_name = "${local.app_name}-runner"

  subscription_id = data.azurerm_subscription.current.id

  github_org              = var.github.org
  github_repository       = var.github.repository
  github_environment_name = "${var.env}-runner"

  container_app_github_runner_env_rg = local.container_app_github_runner_env_rg

}
