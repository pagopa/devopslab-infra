resource "azuread_directory_role" "directory_readers" {
  display_name = "Directory Readers"
}

data "azurerm_storage_account" "tfstate_storage" {
  name                = local.tfstate_storage_account_name
  resource_group_name = local.tfstate_storage_account_rg_name
}

data "azurerm_resource_group" "github_runner_rg" {
  name = local.container_app_github_runner_env_rg
}

data "github_organization_teams" "all" {
  root_teams_only = true
  summary_only    = true
}
