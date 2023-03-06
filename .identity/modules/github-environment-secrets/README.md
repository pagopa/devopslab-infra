# github-environment-secrets

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.secrets](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_environment_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Github repository name | `string` | n/a | yes |
| <a name="input_github_repository_environment_name"></a> [github\_repository\_environment\_name](#input\_github\_repository\_environment\_name) | Github repository environemt name | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | secrets to create | `map(any)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
