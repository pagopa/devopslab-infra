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
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.18 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 3388ff860b06c99d19e0bbba205a553343fca059 |
| <a name="module_dns_forwarder_lb_vmss"></a> [dns\_forwarder\_lb\_vmss](#module\_dns\_forwarder\_lb\_vmss) | ./.terraform/modules/__v4__/dns_forwarder_lb_vmss | n/a |
| <a name="module_packer_azdo_snet"></a> [packer\_azdo\_snet](#module\_packer\_azdo\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_packer_dns_forwarder_snet"></a> [packer\_dns\_forwarder\_snet](#module\_packer\_dns\_forwarder\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_subnet_dns_forwarder_lb"></a> [subnet\_dns\_forwarder\_lb](#module\_subnet\_dns\_forwarder\_lb) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_subnet_dns_forwarder_vmss"></a> [subnet\_dns\_forwarder\_vmss](#module\_subnet\_dns\_forwarder\_vmss) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_vnet_ita_peering"></a> [vnet\_ita\_peering](#module\_vnet\_ita\_peering) | ./.terraform/modules/__v4__/virtual_network_peering | n/a |
| <a name="module_vnet_italy"></a> [vnet\_italy](#module\_vnet\_italy) | ./.terraform/modules/__v4__/virtual_network | n/a |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ./.terraform/modules/__v4__/vpn_gateway | n/a |
| <a name="module_vpn_snet"></a> [vpn\_snet](#module\_vpn\_snet) | ./.terraform/modules/__v4__/subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg_ita_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azuread_application.vpn_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) | data source |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.rg_vnet_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_ita_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_legacy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_subnet_dnsforwarder_lb"></a> [cidr\_subnet\_dnsforwarder\_lb](#input\_cidr\_subnet\_dnsforwarder\_lb) | DNS Forwarder network address space for LB. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_dnsforwarder_vmss"></a> [cidr\_subnet\_dnsforwarder\_vmss](#input\_cidr\_subnet\_dnsforwarder\_vmss) | DNS Forwarder network address space for VMSS. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_packer_azdo"></a> [cidr\_subnet\_packer\_azdo](#input\_cidr\_subnet\_packer\_azdo) | packer azdo network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_packer_dns_forwarder"></a> [cidr\_subnet\_packer\_dns\_forwarder](#input\_cidr\_subnet\_packer\_dns\_forwarder) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_vpn"></a> [cidr\_subnet\_vpn](#input\_cidr\_subnet\_vpn) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet_italy"></a> [cidr\_vnet\_italy](#input\_cidr\_vnet\_italy) | Address prefixes for vnet in italy. | `list(string)` | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | value | `number` | `3600` | no |
| <a name="input_dns_forwarder_vmss_image_version"></a> [dns\_forwarder\_vmss\_image\_version](#input\_dns\_forwarder\_vmss\_image\_version) | vpn dns forwarder image version | `string` | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: itn.. | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"dvopla"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_vnet_ita_ddos_protection_plan"></a> [vnet\_ita\_ddos\_protection\_plan](#input\_vnet\_ita\_ddos\_protection\_plan) | ## Italy location | <pre>object({<br/>    id     = string<br/>    enable = bool<br/>  })</pre> | `null` | no |
| <a name="input_vpn_pip_sku"></a> [vpn\_pip\_sku](#input\_vpn\_pip\_sku) | VPN GW PIP SKU | `string` | n/a | yes |
| <a name="input_vpn_sku"></a> [vpn\_sku](#input\_vpn\_sku) | VPN Gateway SKU | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
