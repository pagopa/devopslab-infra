# app-github-runner-ci

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.environment_ci](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.environment_ci](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_group_member.add_environment_ci_to_directory_readers_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member) | resource |
| [azuread_service_principal.environment_ci](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.environment_ci_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.environment_ci_tfstate_inf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.pagopa_iac_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuread_group.group_github_runners_iac_permissions](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_storage_account.tfstate_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | App name (SP) | `string` | n/a | yes |
| <a name="input_custom_role_name"></a> [custom\_role\_name](#input\_custom\_role\_name) | Custom role that allows IaC SP to read resources and generate kubernetes credentials | `string` | `"PagoPA IaC Reader"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment Name | `string` | n/a | yes |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | GitHub Organization | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub Repository | `string` | n/a | yes |
| <a name="input_iac_aad_group_name"></a> [iac\_aad\_group\_name](#input\_iac\_aad\_group\_name) | Azure AD group name for iac sp apps (with Directory Reader permissions at leats) | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Suscription ID | `string` | n/a | yes |
| <a name="input_tfstate_storage_account_name"></a> [tfstate\_storage\_account\_name](#input\_tfstate\_storage\_account\_name) | Storage name where the tf state is saved | `string` | n/a | yes |
| <a name="input_tfstate_storage_account_rg_name"></a> [tfstate\_storage\_account\_rg\_name](#input\_tfstate\_storage\_account\_rg\_name) | Resopurce group of storage name where the tf state is saved | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | n/a |
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | n/a |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | n/a |
| <a name="output_object_id"></a> [object\_id](#output\_object\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
