<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.76.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azdoa_li"></a> [azdoa\_li](#module\_azdoa\_li) | git::https://github.com/pagopa/azurerm.git//azure_devops_agent | v1.0.57 |
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.3 |
| <a name="module_postgres"></a> [postgres](#module\_postgres) | git::https://github.com/pagopa/azurerm.git//postgresql_server | v2.0.0 |
| <a name="module_postgres_snet"></a> [postgres\_snet](#module\_postgres\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.84 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/azurerm.git//virtual_network | v1.0.51 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/application_insights) | resource |
| [azurerm_dns_ns_record.dev_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_ns_record.uat_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/dns_zone) | resource |
| [azurerm_key_vault_access_policy.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.application_insights_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/monitor_action_group) | resource |
| [azurerm_postgresql_server_key.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/postgresql_server_key) | resource |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.privatelink_postgres_database_azure_com](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.internal_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privatelink_postgres_database_azure_com_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.aks_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.appgateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azdo_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/resources/resource_group) | resource |
| [azuread_group.postgres](https://registry.terraform.io/providers/hashicorp/azuread/2.3.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.monitor_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_slack_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.postgres_administrator_login](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.postgres_administrator_login_password](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.76.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_cidr_subnet_azdoa"></a> [cidr\_subnet\_azdoa](#input\_cidr\_subnet\_azdoa) | Azure DevOps agent network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_postgres"></a> [cidr\_subnet\_postgres](#input\_cidr\_subnet\_postgres) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | value | `number` | `3600` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | n/a | yes |
| <a name="input_enable_iac_pipeline"></a> [enable\_iac\_pipeline](#input\_enable\_iac\_pipeline) | If true create the key vault policy to allow used by azure devops iac pipelines. | `bool` | `false` | no |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key Vault name | `string` | `""` | no |
| <a name="input_key_vault_rg_name"></a> [key\_vault\_rg\_name](#input\_key\_vault\_rg\_name) | Key Vault - rg name | `string` | `""` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_postgres_alerts_enabled"></a> [postgres\_alerts\_enabled](#input\_postgres\_alerts\_enabled) | Database alerts enabled? | `bool` | `false` | no |
| <a name="input_postgres_byok_enabled"></a> [postgres\_byok\_enabled](#input\_postgres\_byok\_enabled) | Enable postgresql encryption with Customer Managed Key (BYOK) | `bool` | `false` | no |
| <a name="input_postgres_geo_redundant_backup_enabled"></a> [postgres\_geo\_redundant\_backup\_enabled](#input\_postgres\_geo\_redundant\_backup\_enabled) | Turn Geo-redundant server backups on/off. | `bool` | `false` | no |
| <a name="input_postgres_network_rules"></a> [postgres\_network\_rules](#input\_postgres\_network\_rules) | Database network rules | <pre>object({<br>    ip_rules                       = list(string)<br>    allow_access_to_azure_services = bool<br>  })</pre> | <pre>{<br>  "allow_access_to_azure_services": false,<br>  "ip_rules": []<br>}</pre> | no |
| <a name="input_postgres_private_endpoint_enabled"></a> [postgres\_private\_endpoint\_enabled](#input\_postgres\_private\_endpoint\_enabled) | Enable vnet private endpoint for postgres | `bool` | n/a | yes |
| <a name="input_postgres_public_network_access_enabled"></a> [postgres\_public\_network\_access\_enabled](#input\_postgres\_public\_network\_access\_enabled) | Enable/Disable public network access | `bool` | `false` | no |
| <a name="input_postgres_sku_name"></a> [postgres\_sku\_name](#input\_postgres\_sku\_name) | Specifies the SKU Name for this PostgreSQL Server. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"usrreg"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
