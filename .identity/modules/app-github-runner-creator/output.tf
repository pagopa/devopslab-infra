output "display_name" {
  value = var.app_name
}

output "client_id" {
  value = azuread_service_principal.github_app.application_id
}

output "application_id" {
  value = azuread_service_principal.github_app.application_id
}

output "object_id" {
  value = azuread_service_principal.github_app.object_id
}
