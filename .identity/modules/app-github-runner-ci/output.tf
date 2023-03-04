output "azure_environment_ci" {
  value = {
    app_name       = var.app_name
    client_id      = azuread_service_principal.environment_ci.application_id
    application_id = azuread_service_principal.environment_ci.application_id
    object_id      = azuread_service_principal.environment_ci.object_id
  }
}
