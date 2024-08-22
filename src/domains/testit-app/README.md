<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | <= 2.47.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.115.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | <= 2.12.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | <= 2.35.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | <= 2.5.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | <= 3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_mounter"></a> [cert\_mounter](#module\_cert\_mounter) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter | v8.38.0 |
| <a name="module_domain_pod_identity"></a> [domain\_pod\_identity](#module\_domain\_pod\_identity) | git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_pod_identity | v8.17.1 |
| <a name="module_system_service_account"></a> [system\_service\_account](#module\_system\_service\_account) | git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_service_account | v8.17.1 |
| <a name="module_tls_checker"></a> [tls\_checker](#module\_tls\_checker) | git::https://github.com/pagopa/terraform-azurerm-v3.git//tls_checker | v8.38.0 |
| <a name="module_workload_identity"></a> [workload\_identity](#module\_workload\_identity) | git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity | v8.39.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.aks_apiserver_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.app_insights_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_kubernetes_cluster_node_pool.user_nodepool_testit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_private_dns_a_record.itn_testit_ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_subnet.user_testit_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.system_domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_persistent_volume_claim_v1.testit_file_share_zrs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1) | resource |
| [kubernetes_persistent_volume_claim_v1.testit_hdd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1) | resource |
| [kubernetes_persistent_volume_claim_v1.testit_ssd_az](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1) | resource |
| [kubernetes_role_binding.deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.system_deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.rg_vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.vnet_italy_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_italy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_aks_user_node_pool_testit"></a> [aks\_user\_node\_pool\_testit](#input\_aks\_user\_node\_pool\_testit) | AKS node pool user configuration | <pre>object({<br>    name                       = string,<br>    vm_size                    = string,<br>    os_disk_type               = string,<br>    os_disk_size_gb            = string,<br>    node_count_min             = number,<br>    node_count_max             = number,<br>    node_labels                = map(any),<br>    node_taints                = list(string),<br>    node_tags                  = map(any),<br>    ultra_ssd_enabled          = optional(bool, false),<br>    enable_host_encryption     = optional(bool, true),<br>    max_pods                   = optional(number, 250),<br>    upgrade_settings_max_surge = optional(string, "30%"),<br>    zones                      = optional(list(any), [1, 2, 3]),<br>  })</pre> | n/a | yes |
| <a name="input_cidr_subnet_user_aks_testit"></a> [cidr\_subnet\_user\_aks\_testit](#input\_cidr\_subnet\_user\_aks\_testit) | Subnet cluster kubernetes. | `list(string)` | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_port"></a> [event\_hub\_port](#input\_event\_hub\_port) | n/a | `number` | `9093` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_ingress_load_balancer_hostname"></a> [ingress\_load\_balancer\_hostname](#input\_ingress\_load\_balancer\_hostname) | n/a | `string` | `""` | no |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_is_feature_enabled"></a> [is\_feature\_enabled](#input\_is\_feature\_enabled) | n/a | <pre>object({<br>    nodepool_dedicated = bool<br>  })</pre> | <pre>{<br>  "nodepool_dedicated": false<br>}</pre> | no |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_rg_vnet_italy_name"></a> [rg\_vnet\_italy\_name](#input\_rg\_vnet\_italy\_name) | Resource group dedicated to VNet AKS | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_tls_cert_check_helm"></a> [tls\_cert\_check\_helm](#input\_tls\_cert\_check\_helm) | tls cert helm chart configuration | <pre>object({<br>    chart_version = string,<br>    image_name    = string,<br>    image_tag     = string<br>  })</pre> | n/a | yes |
| <a name="input_vnet_italy_name"></a> [vnet\_italy\_name](#input\_vnet\_italy\_name) | VNet dedicated to AKS | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
