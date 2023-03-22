module "github_runner_cd" {
  source = "git::https://github.com/pagopa/github-actions-tf-modules.git//app-github-runner-cd?ref=main"


  app_name           = "${local.app_name}-cd"
  iac_aad_group_name = "github-runners-iac-permissions"

  subscription_id = data.azurerm_subscription.current.id

  github_org              = var.github.org
  github_repository       = var.github.repository
  github_environment_name = "${var.env}-cd"

  tfstate_storage_account_name    = local.tfstate_storage_account_name
  tfstate_storage_account_rg_name = local.tfstate_storage_account_rg_name

}

module "github_runner_ci" {
  source = "git::https://github.com/pagopa/github-actions-tf-modules.git//app-github-runner-ci?ref=main"

  app_name           = "${local.app_name}-ci"
  iac_aad_group_name = "github-runners-iac-permissions"

  env             = var.env
  subscription_id = data.azurerm_subscription.current.id

  github_org        = var.github.org
  github_repository = var.github.repository

  tfstate_storage_account_name    = local.tfstate_storage_account_name
  tfstate_storage_account_rg_name = local.tfstate_storage_account_rg_name
}

module "github_runner_creator" {
  source = "git::https://github.com/pagopa/github-actions-tf-modules.git//app-github-runner-creator?ref=main"


  app_name = "${local.app_name}-runner"

  subscription_id = data.azurerm_subscription.current.id

  github_org              = var.github.org
  github_repository       = var.github.repository
  github_environment_name = "${var.env}-runner"

  container_app_github_runner_env_rg = local.container_app_github_runner_env_rg

}
