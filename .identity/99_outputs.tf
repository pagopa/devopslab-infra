output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "cd_service_principal_github_action_name" {
  value = azuread_service_principal.environment_cd.display_name
}

output "ci_service_principal_github_action_name" {
  value = azuread_service_principal.environment_ci.display_name
}
