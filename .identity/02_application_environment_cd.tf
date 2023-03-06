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


# resource "azuread_application" "environment_cd" {
#   display_name = "${local.app_name}-cd"
# }

# resource "azuread_service_principal" "environment_cd" {
#   application_id = azuread_application.environment_cd.application_id
# }

# resource "azuread_application_federated_identity_credential" "environment_cd" {
#   application_object_id = azuread_application.environment_cd.object_id
#   display_name          = "github-federated"
#   description           = "github-federated"
#   audiences             = ["api://AzureADTokenExchange"]
#   issuer                = "https://token.actions.githubusercontent.com"
#   subject               = "repo:${var.github.org}/${var.github.repository}:environment:${var.env}-cd"
# }

# resource "azuread_directory_role_assignment" "environment_cd_directory_readers" {
#   role_id             = azuread_directory_role.directory_readers.template_id
#   principal_object_id = azuread_service_principal.environment_cd.object_id
# }

# resource "azurerm_role_assignment" "environment_cd_subscription" {
#   for_each             = toset(var.environment_cd_roles.subscription)
#   scope                = data.azurerm_subscription.current.id
#   role_definition_name = each.key
#   principal_id         = azuread_service_principal.environment_cd.object_id
# }

# resource "azurerm_role_assignment" "environment_cd_tfstate_inf" {
#   scope                = data.azurerm_storage_account.tfstate_storage.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azuread_service_principal.environment_cd.object_id
# }

# output "azure_environment_cd" {
#   value = {
#     app_name       = "${local.app_name}-cd"
#     client_id      = azuread_service_principal.environment_cd.application_id
#     application_id = azuread_service_principal.environment_cd.application_id
#     object_id      = azuread_service_principal.environment_cd.object_id
#   }
# }
