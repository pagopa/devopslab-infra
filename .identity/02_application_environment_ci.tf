module "github_runner_ci" {
  source = "./modules/app-github-runner-ci"

  app_name           = "${local.app_name}-ci"
  iac_aad_group_name = "github-runners-iac-permissions"

  env             = var.env
  subscription_id = data.azurerm_subscription.current.id

  github_org        = var.github.org
  github_repository = var.github.repository

  tfstate_storage_account_name    = local.tfstate_storage_account_name
  tfstate_storage_account_rg_name = local.tfstate_storage_account_rg_name
}
