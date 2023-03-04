module "github_runner_ci" {
  source = "./modules/app-github-runner-ci"

  env = var.env
  app_name = "${local.app_name}-ci"
  iac_aad_group_name = "github-runners-iac-permissions"
  subscription_id = data.azurerm_subscription.current.id

  github_org = "pagopaspa"
  github_repository = "devopslab-infra"

  tfstate_storage_account_name    = "dvopladstinfraterraform"
  tfstate_storage_account_rg_name = "io-infra-rg"
}
