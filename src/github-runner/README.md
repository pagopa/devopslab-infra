# github-runner

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.116.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | v8.50.0 |
| <a name="module_container_app_environment_runner"></a> [container\_app\_environment\_runner](#module\_container\_app\_environment\_runner) | ./.terraform/modules/__v3__/container_app_environment_v2 | n/a |
| <a name="module_container_app_job"></a> [container\_app\_job](#module\_container\_app\_job) | ./.terraform/modules/__v3__/container_app_job_gh_runner_v2 | n/a |
| <a name="module_identity_cd_01"></a> [identity\_cd\_01](#module\_identity\_cd\_01) | ./.terraform/modules/__v3__/github_federated_identity | n/a |
| <a name="module_subnet_runner"></a> [subnet\_runner](#module\_subnet\_runner) | ./.terraform/modules/__v3__/subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.gha_iac_managed_identities](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_management_lock.lock_cae](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_resource_group.rg_github_runner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [null_resource.github_runner_app_permissions_to_namespace_cd_01](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault_common](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.law_common](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.rg_common](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_common](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_key_vault_common"></a> [key\_vault\_common](#input\_key\_vault\_common) | n/a | <pre>object({<br/>    name            = string<br/>    pat_secret_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_law_name"></a> [law\_name](#input\_law\_name) | n/a | `string` | `"Log Analytics Workspace name"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"northeurope"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | n/a | `string` | `"neu"` | no |
| <a name="input_networking"></a> [networking](#input\_networking) | n/a | <pre>object({<br/>    vnet_common_name  = string<br/>    subnet_cidr_block = string<br/>  })</pre> | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_job_id"></a> [ca\_job\_id](#output\_ca\_job\_id) | Container App job id |
| <a name="output_ca_job_name"></a> [ca\_job\_name](#output\_ca\_job\_name) | Container App job name |
| <a name="output_cae_id"></a> [cae\_id](#output\_cae\_id) | Container App Environment id |
| <a name="output_cae_name"></a> [cae\_name](#output\_cae\_name) | Container App Environment name |
| <a name="output_github_manage_identity_client_id"></a> [github\_manage\_identity\_client\_id](#output\_github\_manage\_identity\_client\_id) | Managed identity client ID |
| <a name="output_github_manage_identity_name"></a> [github\_manage\_identity\_name](#output\_github\_manage\_identity\_name) | Managed identity name |
| <a name="output_github_manage_identity_principal_id"></a> [github\_manage\_identity\_principal\_id](#output\_github\_manage\_identity\_principal\_id) | Managed identity principal ID |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Subnet id |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Subnet name |
<!-- END_TF_DOCS -->
