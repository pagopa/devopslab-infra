prefix    = "dvopla"
env_short = "d"
env       = "dev"

github = {
  org        = "pagopa"
  repository = "devopslab-infra"
}

environment_ci_roles = {
  subscription = [
    "Reader",
    "Reader and Data Access",
    "Storage Blob Data Reader",
    "Storage File Data SMB Share Reader",
    "Storage Queue Data Reader",
    "Storage Table Data Reader",
    "PagoPA Export Deployments Template",
    "Key Vault Secrets User",
    "DocumentDB Account Contributor",
    "API Management Service Contributor",
  ]
}

github_repository_environment_ci = {
  protected_branches     = false
  custom_branch_policies = true
}

environment_cd_roles = {
  subscription = [
    "Contributor",
    "Storage Account Contributor",
    "Storage Blob Data Contributor",
    "Storage File Data SMB Share Contributor",
    "Storage Queue Data Contributor",
    "Storage Table Data Contributor",
  ]
}

github_repository_environment_cd = {
  protected_branches     = false
  custom_branch_policies = true
  reviewers_teams        = ["infrastructure-admins"]
}
