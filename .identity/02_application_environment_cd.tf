module "github_runner_cd" {
  source = "./modules/app-github-runner-cd"

  app_name           = "${local.app_name}-cd"
  iac_aad_group_name = "github-runners-iac-permissions"

  subscription_id = data.azurerm_subscription.current.id

  github_org              = var.github.org
  github_repository       = var.github.repository
  github_environment_name = "${var.env}-cd"

  tfstate_storage_account_name    = local.tfstate_storage_account_name
  tfstate_storage_account_rg_name = local.tfstate_storage_account_rg_name

}
