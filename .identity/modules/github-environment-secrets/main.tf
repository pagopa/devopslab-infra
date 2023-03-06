#tfsec:ignore:github-actions-no-plain-text-action-secrets # not real secret
resource "github_actions_environment_secret" "secrets" {
  for_each        = var.secrets
  repository      = var.github_repository
  environment     = var.github_repository_environment_name
  secret_name     = each.key
  plaintext_value = each.value
}

# #tfsec:ignore:github-actions-no-plain-text-action-secrets # not real secret
# resource "github_actions_environment_secret" "azure_ci_tenant_id" {
#   repository      = var.github_repository
#   environment     = var.github_repository_environment_name
#   secret_name     = "AZURE_TENANT_ID"
#   plaintext_value = data.azurerm_client_config.current.tenant_id
# }

# #tfsec:ignore:github-actions-no-plain-text-action-secrets # not real secret
# resource "github_actions_environment_secret" "azure_ci_subscription_id" {
#   repository      = var.github_repository
#   environment     = var.github_repository_environment_name
#   secret_name     = "AZURE_SUBSCRIPTION_ID"
#   plaintext_value = data.azurerm_subscription.current.subscription_id
# }

# #tfsec:ignore:github-actions-no-plain-text-action-secrets # not real secret
# resource "github_actions_environment_secret" "azure_ci_client_id" {
#   repository      = var.github_repository
#   environment     = var.github_repository_environment_name
#   secret_name     = "AZURE_CLIENT_ID"
#   plaintext_value = azuread_service_principal.environment_ci.application_id
# }

# #tfsec:ignore:github-actions-no-plain-text-action-secrets # not real secret
# resource "github_actions_environment_secret" "azure_ci_container_app_environment_name" {
#   repository      = var.github_repository
#   environment     = var.github_repository_environment_name
#   secret_name     = "AZURE_CONTAINER_APP_ENVIRONMENT_NAME"
#   plaintext_value = local.container_app_github_runner_env_name
# }

# #tfsec:ignore:github-actions-no-plain-text-action-secrets # not real secret
# resource "github_actions_environment_secret" "azure_ci_resource_group_name" {
#   repository      = var.github_repository
#   environment     = var.github_repository_environment_name
#   secret_name     = "AZURE_RESOURCE_GROUP_NAME"
#   plaintext_value = local.container_app_github_runner_env_rg
# }
