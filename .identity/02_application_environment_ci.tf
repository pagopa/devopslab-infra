resource "azuread_application" "environment_ci" {
  display_name = "${local.app_name}-ci"
}

resource "azuread_service_principal" "environment_ci" {
  application_id = azuread_application.environment_ci.application_id
}

resource "azuread_application_federated_identity_credential" "environment_ci" {
  application_object_id = azuread_application.environment_ci.object_id
  display_name          = "github-federated"
  description           = "github-federated"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:${var.github.org}/${var.github.repository}:environment:${var.env}-ci"
}

# assign SP to group with Directory Reader
resource "azuread_group_member" "add_environment_ci_to_directory_readers_group" {
  group_object_id  = data.azuread_group.github_runners_iac_permissions.id
  member_object_id = azuread_service_principal.environment_ci.object_id
}

resource "azurerm_role_assignment" "environment_ci_subscription" {
  for_each             = toset(var.environment_ci_roles.subscription)
  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.key
  principal_id         = azuread_service_principal.environment_ci.object_id
}

resource "azurerm_role_assignment" "environment_ci_tfstate_inf" {
  scope                = data.azurerm_storage_account.tfstate_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.environment_ci.object_id
}

output "azure_environment_ci" {
  value = {
    app_name       = "${local.app_name}-ci"
    client_id      = azuread_service_principal.environment_ci.application_id
    application_id = azuread_service_principal.environment_ci.application_id
    object_id      = azuread_service_principal.environment_ci.object_id
  }
}
