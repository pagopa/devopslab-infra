# Pillar

## DNS setup devopslab.pagopa.it

```bash
az network dns zone show \
  --name "devopslab.pagopa.it" \
  --resource-group "dvopla-d-vnet-rg" \
  --subscription "DevOpsLab" \
  --query nameServers
```

## DNS Setup lab.devopslab.pagopa.it

```bash
az network dns zone show \
  --name "lab.devopslab.pagopa.it" \
  --resource-group "dvopla-d-vnet-rg" \
  --subscription "DevOpsLab" \
  --query nameServers
```


<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | <= 1.12.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | <= 2.47.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.101.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | <= 2.3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | <= 3.2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | <= 3.6.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | <= 4.0.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_azdoa_vmss_li"></a> [azdoa\_vmss\_li](#module\_azdoa\_vmss\_li) | git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent | v8.13.0 |
| <a name="module_container_app_environment"></a> [container\_app\_environment](#module\_container\_app\_environment) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment_v2 | v8.13.0 |
| <a name="module_container_registry_public"></a> [container\_registry\_public](#module\_container\_registry\_public) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_registry | v8.13.0 |
| <a name="module_dns_forwarder_lb_vmss"></a> [dns\_forwarder\_lb\_vmss](#module\_dns\_forwarder\_lb\_vmss) | git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder_lb_vmss | v8.13.0 |
| <a name="module_identity_cd_01"></a> [identity\_cd\_01](#module\_identity\_cd\_01) | github.com/pagopa/terraform-azurerm-v3//github_federated_identity | v8.13.0 |
| <a name="module_key_vault_core_ita"></a> [key\_vault\_core\_ita](#module\_key\_vault\_core\_ita) | github.com/pagopa/terraform-azurerm-v3.git//key_vault | v8.13.0 |
| <a name="module_packer_azdo_snet"></a> [packer\_azdo\_snet](#module\_packer\_azdo\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_packer_dns_forwarder_snet"></a> [packer\_dns\_forwarder\_snet](#module\_packer\_dns\_forwarder\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_postgres"></a> [postgres](#module\_postgres) | git::https://github.com/pagopa/terraform-azurerm-v3.git//postgresql_server | v8.13.0 |
| <a name="module_postgres_snet"></a> [postgres\_snet](#module\_postgres\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_private_endpoints_snet"></a> [private\_endpoints\_snet](#module\_private\_endpoints\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache | v8.13.0 |
| <a name="module_redis_snet"></a> [redis\_snet](#module\_redis\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_subnet_dns_forwarder_lb"></a> [subnet\_dns\_forwarder\_lb](#module\_subnet\_dns\_forwarder\_lb) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_subnet_dns_forwarder_vmss"></a> [subnet\_dns\_forwarder\_vmss](#module\_subnet\_dns\_forwarder\_vmss) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network | v8.13.0 |
| <a name="module_vnet_ita_peering"></a> [vnet\_ita\_peering](#module\_vnet\_ita\_peering) | git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering | v8.13.0 |
| <a name="module_vnet_italy"></a> [vnet\_italy](#module\_vnet\_italy) | git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network | v8.13.0 |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | git::https://github.com/pagopa/terraform-azurerm-v3.git//vpn_gateway | v8.13.0 |
| <a name="module_vpn_snet"></a> [vpn\_snet](#module\_vpn\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights.application_insights_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_dns_a_record.api_devopslab_pagopa_it](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_cname_record.public_healthy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_key_vault_access_policy.adgroup_admin_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_developers_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_externals_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_security_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.application_insights_ita_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.application_insights_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.pg_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.pg_admin_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.email_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.slack_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_private_dns_zone.internal_devopslab](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.privatelink_postgres_database_azure_com](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.privatelink_postgres_database_azure_com_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage_account_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.aks_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.apim_management_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.apim_management_public_ip_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.appgateway_beta_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.appgateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azdo_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.managed_identities_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_ita_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_docker](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_ita_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.tools_cae_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.tools_cae_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [random_password.pg_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_application.vpn_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) | data source |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.monitor_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_slack_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_resource_group.identity_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_ephemeral_num_outbound_ips"></a> [aks\_ephemeral\_num\_outbound\_ips](#input\_aks\_ephemeral\_num\_outbound\_ips) | How many outbound ips allocate for AKS prod cluster | `number` | `1` | no |
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_apim_api_internal_certificate_name"></a> [apim\_api\_internal\_certificate\_name](#input\_apim\_api\_internal\_certificate\_name) | KeyVault certificate name | `string` | n/a | yes |
| <a name="input_apim_enabled"></a> [apim\_enabled](#input\_apim\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | Apim publisher name | `string` | `""` | no |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | APIM SKU type | `string` | n/a | yes |
| <a name="input_apim_subnet_nsg_security_rules"></a> [apim\_subnet\_nsg\_security\_rules](#input\_apim\_subnet\_nsg\_security\_rules) | Network security rules for APIM subnet | `list(any)` | n/a | yes |
| <a name="input_azdoa_image_name"></a> [azdoa\_image\_name](#input\_azdoa\_image\_name) | Azure DevOps Agent image name | `string` | n/a | yes |
| <a name="input_cidr_subnet_apim"></a> [cidr\_subnet\_apim](#input\_cidr\_subnet\_apim) | Address prefixes subnet api management. | `list(string)` | `null` | no |
| <a name="input_cidr_subnet_apim_stv2"></a> [cidr\_subnet\_apim\_stv2](#input\_cidr\_subnet\_apim\_stv2) | Address prefixes subnet api management stv2. | `list(string)` | `null` | no |
| <a name="input_cidr_subnet_azdoa"></a> [cidr\_subnet\_azdoa](#input\_cidr\_subnet\_azdoa) | Azure DevOps agent network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_dnsforwarder_lb"></a> [cidr\_subnet\_dnsforwarder\_lb](#input\_cidr\_subnet\_dnsforwarder\_lb) | DNS Forwarder network address space for LB. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_dnsforwarder_vmss"></a> [cidr\_subnet\_dnsforwarder\_vmss](#input\_cidr\_subnet\_dnsforwarder\_vmss) | DNS Forwarder network address space for VMSS. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_packer_azdo"></a> [cidr\_subnet\_packer\_azdo](#input\_cidr\_subnet\_packer\_azdo) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_packer_dns_forwarder"></a> [cidr\_subnet\_packer\_dns\_forwarder](#input\_cidr\_subnet\_packer\_dns\_forwarder) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_postgres"></a> [cidr\_subnet\_postgres](#input\_cidr\_subnet\_postgres) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_private_endpoints"></a> [cidr\_subnet\_private\_endpoints](#input\_cidr\_subnet\_private\_endpoints) | Subnet cidr postgres flex. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_redis"></a> [cidr\_subnet\_redis](#input\_cidr\_subnet\_redis) | Redis. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_tools_cae"></a> [cidr\_subnet\_tools\_cae](#input\_cidr\_subnet\_tools\_cae) | n/a | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_vpn"></a> [cidr\_subnet\_vpn](#input\_cidr\_subnet\_vpn) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet_italy"></a> [cidr\_vnet\_italy](#input\_cidr\_vnet\_italy) | Address prefixes for vnet in italy. | `list(string)` | n/a | yes |
| <a name="input_container_app_tools_cae_env_rg"></a> [container\_app\_tools\_cae\_env\_rg](#input\_container\_app\_tools\_cae\_env\_rg) | Container app env | `string` | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | value | `number` | `3600` | no |
| <a name="input_dns_forwarder_enabled"></a> [dns\_forwarder\_enabled](#input\_dns\_forwarder\_enabled) | Enable dns forwarder setup | `bool` | `false` | no |
| <a name="input_dns_forwarder_is_enabled"></a> [dns\_forwarder\_is\_enabled](#input\_dns\_forwarder\_is\_enabled) | Allow to enable or disable dns forwarder backup | `bool` | `true` | no |
| <a name="input_dns_forwarder_vmss_image_name"></a> [dns\_forwarder\_vmss\_image\_name](#input\_dns\_forwarder\_vmss\_image\_name) | vpn dns forwarder image name | `string` | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | n/a | yes |
| <a name="input_enable_iac_pipeline"></a> [enable\_iac\_pipeline](#input\_enable\_iac\_pipeline) | If true create the key vault policy to allow used by azure devops iac pipelines. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_is_resource_core_enabled"></a> [is\_resource\_core\_enabled](#input\_is\_resource\_core\_enabled) | Feature flags | <pre>object({<br>    postgresql_server = bool,<br>  })</pre> | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key Vault name | `string` | `""` | no |
| <a name="input_key_vault_rg_name"></a> [key\_vault\_rg\_name](#input\_key\_vault\_rg\_name) | Key Vault - rg name | `string` | `""` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_location_ita"></a> [location\_ita](#input\_location\_ita) | Main location | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_location_short_ita"></a> [location\_short\_ita](#input\_location\_short\_ita) | Location short for italy: itn | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_postgres_alerts_enabled"></a> [postgres\_alerts\_enabled](#input\_postgres\_alerts\_enabled) | Database alerts enabled? | `bool` | `false` | no |
| <a name="input_postgres_byok_enabled"></a> [postgres\_byok\_enabled](#input\_postgres\_byok\_enabled) | Enable postgresql encryption with Customer Managed Key (BYOK) | `bool` | `false` | no |
| <a name="input_postgres_network_rules"></a> [postgres\_network\_rules](#input\_postgres\_network\_rules) | Database network rules | <pre>object({<br>    ip_rules                       = list(string)<br>    allow_access_to_azure_services = bool<br>  })</pre> | <pre>{<br>  "allow_access_to_azure_services": false,<br>  "ip_rules": []<br>}</pre> | no |
| <a name="input_postgres_private_endpoint_enabled"></a> [postgres\_private\_endpoint\_enabled](#input\_postgres\_private\_endpoint\_enabled) | Enable vnet private endpoint for postgres | `bool` | n/a | yes |
| <a name="input_postgres_public_network_access_enabled"></a> [postgres\_public\_network\_access\_enabled](#input\_postgres\_public\_network\_access\_enabled) | Enable/Disable public network access | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"dvopla"` | no |
| <a name="input_redis_enabled"></a> [redis\_enabled](#input\_redis\_enabled) | Redis | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_vnet_ita_ddos_protection_plan"></a> [vnet\_ita\_ddos\_protection\_plan](#input\_vnet\_ita\_ddos\_protection\_plan) | ## Italy location | <pre>object({<br>    id     = string<br>    enable = bool<br>  })</pre> | `null` | no |
| <a name="input_vpn_enabled"></a> [vpn\_enabled](#input\_vpn\_enabled) | Enable VPN setup | `bool` | `false` | no |
| <a name="input_vpn_pip_sku"></a> [vpn\_pip\_sku](#input\_vpn\_pip\_sku) | VPN GW PIP SKU | `string` | n/a | yes |
| <a name="input_vpn_sku"></a> [vpn\_sku](#input\_vpn\_sku) | VPN Gateway SKU | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
