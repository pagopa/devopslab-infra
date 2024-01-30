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
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.10.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.71.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apim"></a> [apim](#module\_apim) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management | v7.23.0 |
| <a name="module_apim_blueprint_status_v1"></a> [apim\_blueprint\_status\_v1](#module\_apim\_blueprint\_status\_v1) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v7.23.0 |
| <a name="module_apim_product_blueprint"></a> [apim\_product\_blueprint](#module\_apim\_product\_blueprint) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v7.23.0 |
| <a name="module_apim_snet"></a> [apim\_snet](#module\_apim\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_apim_stv2_snet"></a> [apim\_stv2\_snet](#module\_apim\_stv2\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_azdoa_vmss_li"></a> [azdoa\_vmss\_li](#module\_azdoa\_vmss\_li) | git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent | v7.23.0 |
| <a name="module_container_registry_private"></a> [container\_registry\_private](#module\_container\_registry\_private) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_registry | v7.23.0 |
| <a name="module_dns_forwarder"></a> [dns\_forwarder](#module\_dns\_forwarder) | git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder | v7.23.0 |
| <a name="module_dns_forwarder_lb_vmss"></a> [dns\_forwarder\_lb\_vmss](#module\_dns\_forwarder\_lb\_vmss) | git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder_lb_vmss | v7.50.0 |
| <a name="module_dns_forwarder_snet"></a> [dns\_forwarder\_snet](#module\_dns\_forwarder\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_postgres"></a> [postgres](#module\_postgres) | git::https://github.com/pagopa/terraform-azurerm-v3.git//postgresql_server | v7.23.0 |
| <a name="module_postgres_snet"></a> [postgres\_snet](#module\_postgres\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_private_endpoints_snet"></a> [private\_endpoints\_snet](#module\_private\_endpoints\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache | v7.23.0 |
| <a name="module_redis_snet"></a> [redis\_snet](#module\_redis\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_security_monitoring_storage"></a> [security\_monitoring\_storage](#module\_security\_monitoring\_storage) | git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account | v7.23.0 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network | v7.23.0 |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | git::https://github.com/pagopa/terraform-azurerm-v3.git//vpn_gateway | v7.23.0 |
| <a name="module_vpn_snet"></a> [vpn\_snet](#module\_vpn\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v7.23.0 |
| <a name="module_web_test_availability_alert_rules_for_api"></a> [web\_test\_availability\_alert\_rules\_for\_api](#module\_web\_test\_availability\_alert\_rules\_for\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//application_insights_web_test_preview | v7.23.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_custom_domain.api_custom_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_custom_domain) | resource |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_dns_a_record.api_devopslab_pagopa_it](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.helm_template_ingress_devopslab_pagopa_it](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_cname_record.lab_healthy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_cname_record.public_healthy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_ns_record.lab_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.lab](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_key_vault_access_policy.api_management_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.application_insights_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_network_security_group.apim_snet_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.apim_snet_nsg_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_a_record.api_internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
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
| [azurerm_resource_group.dns_forwarder](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_docker](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet_network_security_group_association.apim_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.apim_stv2_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azuread_application.vpn_app](https://registry.terraform.io/providers/hashicorp/azuread/2.10.0/docs/data-sources/application) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_certificate.apim_internal_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_secret.apim_publisher_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_slack_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.postgres_administrator_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.postgres_administrator_login_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
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
| <a name="input_cidr_subnet_dns_forwarder_lb"></a> [cidr\_subnet\_dns\_forwarder\_lb](#input\_cidr\_subnet\_dns\_forwarder\_lb) | Address prefixes subnet dns forwarder lb | `list(string)` | `[]` | no |
| <a name="input_cidr_subnet_dns_forwarder_vms"></a> [cidr\_subnet\_dns\_forwarder\_vms](#input\_cidr\_subnet\_dns\_forwarder\_vms) | Address prefixes subnet dns forwarder scale set | `list(string)` | `[]` | no |
| <a name="input_cidr_subnet_dnsforwarder"></a> [cidr\_subnet\_dnsforwarder](#input\_cidr\_subnet\_dnsforwarder) | DNS Forwarder network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_postgres"></a> [cidr\_subnet\_postgres](#input\_cidr\_subnet\_postgres) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_private_endpoints"></a> [cidr\_subnet\_private\_endpoints](#input\_cidr\_subnet\_private\_endpoints) | Subnet cidr postgres flex. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_redis"></a> [cidr\_subnet\_redis](#input\_cidr\_subnet\_redis) | Redis. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_vpn"></a> [cidr\_subnet\_vpn](#input\_cidr\_subnet\_vpn) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | value | `number` | `3600` | no |
| <a name="input_dns_forwarder_enabled"></a> [dns\_forwarder\_enabled](#input\_dns\_forwarder\_enabled) | Enable dns forwarder setup | `bool` | `false` | no |
| <a name="input_dns_forwarder_is_enabled"></a> [dns\_forwarder\_is\_enabled](#input\_dns\_forwarder\_is\_enabled) | Allow to enable or disable dns forwarder backup | `bool` | `true` | no |
| <a name="input_dns_forwarder_lb_backend_pool_ips"></a> [dns\_forwarder\_lb\_backend\_pool\_ips](#input\_dns\_forwarder\_lb\_backend\_pool\_ips) | Backend pool address for dns forwarder load balancer | `map(list(string))` | `{}` | no |
| <a name="input_dns_forwarder_vm_image_name"></a> [dns\_forwarder\_vm\_image\_name](#input\_dns\_forwarder\_vm\_image\_name) | Image name for dns forwarder | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | n/a | yes |
| <a name="input_enable_iac_pipeline"></a> [enable\_iac\_pipeline](#input\_enable\_iac\_pipeline) | If true create the key vault policy to allow used by azure devops iac pipelines. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_is_resource_core_enabled"></a> [is\_resource\_core\_enabled](#input\_is\_resource\_core\_enabled) | Feature flags | <pre>object({<br>    postgresql_server = bool,<br>  })</pre> | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key Vault name | `string` | `""` | no |
| <a name="input_key_vault_rg_name"></a> [key\_vault\_rg\_name](#input\_key\_vault\_rg\_name) | Key Vault - rg name | `string` | `""` | no |
| <a name="input_lab_dns_zone_prefix"></a> [lab\_dns\_zone\_prefix](#input\_lab\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_postgres_alerts_enabled"></a> [postgres\_alerts\_enabled](#input\_postgres\_alerts\_enabled) | Database alerts enabled? | `bool` | `false` | no |
| <a name="input_postgres_byok_enabled"></a> [postgres\_byok\_enabled](#input\_postgres\_byok\_enabled) | Enable postgresql encryption with Customer Managed Key (BYOK) | `bool` | `false` | no |
| <a name="input_postgres_network_rules"></a> [postgres\_network\_rules](#input\_postgres\_network\_rules) | Database network rules | <pre>object({<br>    ip_rules                       = list(string)<br>    allow_access_to_azure_services = bool<br>  })</pre> | <pre>{<br>  "allow_access_to_azure_services": false,<br>  "ip_rules": []<br>}</pre> | no |
| <a name="input_postgres_private_endpoint_enabled"></a> [postgres\_private\_endpoint\_enabled](#input\_postgres\_private\_endpoint\_enabled) | Enable vnet private endpoint for postgres | `bool` | n/a | yes |
| <a name="input_postgres_public_network_access_enabled"></a> [postgres\_public\_network\_access\_enabled](#input\_postgres\_public\_network\_access\_enabled) | Enable/Disable public network access | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"dvopla"` | no |
| <a name="input_prod_dns_zone_prefix"></a> [prod\_dns\_zone\_prefix](#input\_prod\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_redis_enabled"></a> [redis\_enabled](#input\_redis\_enabled) | Redis | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_vpn_enabled"></a> [vpn\_enabled](#input\_vpn\_enabled) | Enable VPN setup | `bool` | `false` | no |
| <a name="input_vpn_pip_sku"></a> [vpn\_pip\_sku](#input\_vpn\_pip\_sku) | VPN GW PIP SKU | `string` | `"Basic"` | no |
| <a name="input_vpn_sku"></a> [vpn\_sku](#input\_vpn\_sku) | VPN Gateway SKU | `string` | `"VpnGw1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
