module "container_app_job" {

  depends_on = [
    module.container_app_environment_runner
  ]

  source = "./.terraform/modules/__v3__/container_app_job_gh_runner_v2"

  location            = var.location
  prefix              = var.prefix
  env_short           = var.env_short
  resource_group_name = azurerm_resource_group.rg_github_runner.name

  job_meta = {
    repo = "devops-app-status"
  }

  key_vault_name        = data.azurerm_key_vault.key_vault_common.name
  key_vault_rg          = data.azurerm_key_vault.key_vault_common.resource_group_name
  key_vault_secret_name = var.key_vault_common.pat_secret_name

  environment_name = module.container_app_environment_runner.name
  environment_rg   = module.container_app_environment_runner.resource_group_name

  polling_interval_in_seconds = 10
  job = {
    name             = "infra"
    repo             = "devops-app-status"
    polling_interval = 20
  }

  container = {
    cpu    = 1
    memory = "2Gi"
    image  = "ghcr.io/pagopa/github-self-hosted-runner-azure:latest"
  }

  tags = var.tags
}
