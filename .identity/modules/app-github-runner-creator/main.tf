data "azurerm_resource_group" "github_runner_rg" {
  name = var.container_app_github_runner_env_rg
}

#
# Create App
#
resource "azuread_application" "github_app" {
  display_name = var.app_name
}

resource "azuread_service_principal" "github_app" {
  application_id = azuread_application.github_app.application_id
}

resource "azuread_application_federated_identity_credential" "github_app" {
  application_object_id = azuread_application.github_app.object_id
  display_name          = "github-federated"
  description           = "github-federated"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:${var.github_org}/${var.github_repository}:environment:${var.github_environment_name}"
}

resource "azurerm_role_assignment" "environment_runner_github_runner_rg" {
  scope                = data.azurerm_resource_group.github_runner_rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_app.object_id
}
