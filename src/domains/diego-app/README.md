<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.38.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.11.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_service_docker_snet"></a> [app\_service\_docker\_snet](#module\_app\_service\_docker\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v4.1.0 |
| <a name="module_diego_app_service_docker"></a> [diego\_app\_service\_docker](#module\_diego\_app\_service\_docker) | git::https://github.com/pagopa/terraform-azurerm-v3.git//app_service | v4.1.0 |
| <a name="module_domain_pod_identity"></a> [domain\_pod\_identity](#module\_domain\_pod\_identity) | git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_pod_identity | v4.1.0 |
| <a name="module_func_python"></a> [func\_python](#module\_func\_python) | git::https://github.com/pagopa/terraform-azurerm-v3.git//function_app | v4.1.0 |
| <a name="module_func_python_staging_slot"></a> [func\_python\_staging\_slot](#module\_func\_python\_staging\_slot) | git::https://github.com/pagopa/terraform-azurerm-v3.git//function_app_slot | v4.1.0 |
| <a name="module_funcs_diego_snet"></a> [funcs\_diego\_snet](#module\_funcs\_diego\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v4.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_plan.app_service_diego_app](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/app_service_plan) | resource |
| [azurerm_app_service_plan.funcs_diego](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/app_service_plan) | resource |
| [azurerm_key_vault_secret.aks_apiserver_url](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_resource_group.app_service_diego_app_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.funcs_diego_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.diego_app_docker_to_acr](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/role_assignment) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubernetes_namespace.domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.system_domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_role_binding.deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.system_deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_service_account.azure_devops](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/client_config) | data source |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/container_registry) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/key_vault) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.rg_vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/virtual_network) | data source |
| [kubernetes_secret.azure_devops_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/data-sources/secret) | data source |
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_app_service_diego_app_is_enabled"></a> [app\_service\_diego\_app\_is\_enabled](#input\_app\_service\_diego\_app\_is\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_app_service_plan_enabled"></a> [app\_service\_plan\_enabled](#input\_app\_service\_plan\_enabled) | App service | `bool` | n/a | yes |
| <a name="input_cidr_subnet_app_diego_app"></a> [cidr\_subnet\_app\_diego\_app](#input\_cidr\_subnet\_app\_diego\_app) | Subnet diego app. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_funcs_diego_domain"></a> [cidr\_subnet\_funcs\_diego\_domain](#input\_cidr\_subnet\_funcs\_diego\_domain) | Subnet for funcs in diego domain | `list(string)` | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_port"></a> [event\_hub\_port](#input\_event\_hub\_port) | n/a | `number` | `9093` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_function_python_diego_enabled"></a> [function\_python\_diego\_enabled](#input\_function\_python\_diego\_enabled) | Is function python enabled. | `bool` | `false` | no |
| <a name="input_ingress_load_balancer_hostname"></a> [ingress\_load\_balancer\_hostname](#input\_ingress\_load\_balancer\_hostname) | n/a | `string` | `""` | no |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_terraform_remote_state_core"></a> [terraform\_remote\_state\_core](#input\_terraform\_remote\_state\_core) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
