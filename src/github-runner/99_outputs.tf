output "subnet_name" {
  value       = module.subnet_runner.name
  description = "Subnet name"
}

output "subnet_id" {
  value       = module.subnet_runner.id
  description = "Subnet id"
}

output "cae_id" {
  value       = module.container_app_environment_runner.id
  description = "Container App Environment id"
}

output "cae_name" {
  value       = module.container_app_environment_runner.name
  description = "Container App Environment name"
}

output "ca_job_id" {
  value       = module.container_app_job.id
  description = "Container App job id"
}

output "ca_job_name" {
  value       = module.container_app_job.name
  description = "Container App job name"
}

output "github_manage_identity_client_id" {
  value       = module.identity_cd_01.identity_client_id
  description = "Managed identity client ID"
}

output "github_manage_identity_principal_id" {
  value       = module.identity_cd_01.identity_principal_id
  description = "Managed identity principal ID"
}

output "github_manage_identity_name" {
  value       = module.identity_cd_01.identity_app_name
  description = "Managed identity name"
}
