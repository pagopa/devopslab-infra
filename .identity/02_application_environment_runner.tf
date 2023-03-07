module "github_runner_creator" {
  source = "./modules/app-github-runner-creator"

  app_name           = "${local.app_name}-runner"

  subscription_id = data.azurerm_subscription.current.id

  github_org        = var.github.org
  github_repository = var.github.repository
  github_environment_name = "${var.env}-runner"

  container_app_github_runner_env_rg = local.container_app_github_runner_env_rg

}

# resource "azuread_application" "environment_runner" {
#   display_name = "${local.app_name}-runner"
# }

# resource "azuread_service_principal" "environment_runner" {
#   application_id = azuread_application.environment_runner.application_id
# }

# resource "azuread_application_federated_identity_credential" "environment_runner" {
#   application_object_id = azuread_application.environment_runner.object_id
#   display_name          = "github-federated"
#   description           = "github-federated"
#   audiences             = ["api://AzureADTokenExchange"]
#   issuer                = "https://token.actions.githubusercontent.com"
#   subject               = "repo:${var.github.org}/${var.github.repository}:environment:${var.env}-runner"
# }

# resource "azurerm_role_assignment" "environment_runner_github_runner_rg" {
#   scope                = data.azurerm_resource_group.github_runner_rg.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_service_principal.environment_runner.object_id
# }

# output "azure_environment_runner" {
#   value = {
#     app_name       = "${local.app_name}-runner"
#     client_id      = azuread_service_principal.environment_runner.application_id
#     application_id = azuread_service_principal.environment_runner.application_id
#     object_id      = azuread_service_principal.environment_runner.object_id
#   }
# }
