output "display_name" {
  value = var.app_name
}

output "client_id" {
  value = azuread_service_principal.environment_ci.application_id
}

output "application_id" {
  value = azuread_service_principal.environment_ci.application_id
}

output "object_id" {
  value = azuread_service_principal.environment_ci.object_id
}
