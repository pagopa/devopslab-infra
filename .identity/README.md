# .identity

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.30.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.45.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 5.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github_environment_cd_secrets"></a> [github\_environment\_cd\_secrets](#module\_github\_environment\_cd\_secrets) | ./modules/github-environment-secrets | n/a |
| <a name="module_github_environment_ci_secrets"></a> [github\_environment\_ci\_secrets](#module\_github\_environment\_ci\_secrets) | ./modules/github-environment-secrets | n/a |
| <a name="module_github_environment_runner_secrets"></a> [github\_environment\_runner\_secrets](#module\_github\_environment\_runner\_secrets) | ./modules/github-environment-secrets | n/a |
| <a name="module_github_runner_cd"></a> [github\_runner\_cd](#module\_github\_runner\_cd) | ./modules/app-github-runner-cd | n/a |
| <a name="module_github_runner_ci"></a> [github\_runner\_ci](#module\_github\_runner\_ci) | ./modules/app-github-runner-ci | n/a |
| <a name="module_github_runner_creator"></a> [github\_runner\_creator](#module\_github\_runner\_creator) | ./modules/app-github-runner-creator | n/a |

## Resources

| Name | Type |
|------|------|
| [github_repository_environment.github_repository_environment_cd](https://registry.terraform.io/providers/integrations/github/5.18.0/docs/resources/repository_environment) | resource |
| [github_repository_environment.github_repository_environment_ci](https://registry.terraform.io/providers/integrations/github/5.18.0/docs/resources/repository_environment) | resource |
| [github_repository_environment.github_repository_environment_runner](https://registry.terraform.io/providers/integrations/github/5.18.0/docs/resources/repository_environment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.45.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.45.0/docs/data-sources/subscription) | data source |
| [github_organization_teams.all](https://registry.terraform.io/providers/integrations/github/5.18.0/docs/data-sources/organization_teams) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_environment_cd_roles"></a> [environment\_cd\_roles](#input\_environment\_cd\_roles) | GitHub Continous Delivery roles | <pre>object({<br>    subscription = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_environment_ci_roles"></a> [environment\_ci\_roles](#input\_environment\_ci\_roles) | GitHub Continous Integration roles | <pre>object({<br>    subscription = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_github"></a> [github](#input\_github) | GitHub Organization and repository name | <pre>object({<br>    org        = string<br>    repository = string<br>  })</pre> | n/a | yes |
| <a name="input_github_repository_environment_cd"></a> [github\_repository\_environment\_cd](#input\_github\_repository\_environment\_cd) | GitHub Continous Integration roles | <pre>object({<br>    protected_branches     = bool<br>    custom_branch_policies = bool<br>    reviewers_teams        = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_github_repository_environment_ci"></a> [github\_repository\_environment\_ci](#input\_github\_repository\_environment\_ci) | GitHub Continous Integration roles | <pre>object({<br>    protected_branches     = bool<br>    custom_branch_policies = bool<br>  })</pre> | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub Organization and repository name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ci_service_principal_github_action_client_id"></a> [ci\_service\_principal\_github\_action\_client\_id](#output\_ci\_service\_principal\_github\_action\_client\_id) | n/a |
| <a name="output_ci_service_principal_github_action_name"></a> [ci\_service\_principal\_github\_action\_name](#output\_ci\_service\_principal\_github\_action\_name) | n/a |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | n/a |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
