# Kubernetes Cluster

## How to install the first time

### Disable components

99_main.tf:

* disable helm and k8s providers, because the aks is undercostruction

04_ingress.tf
04_keda.tf
04_rbac.tf

Comment this files because a cluster is mandatory to work

### Cluster Creation

Launch the cluster creation

### Re-enable resources

Re-enable all the resource, commented before to complete the procedure

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | <= 3.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 4.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.argocd_group_assignments](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_application.argocd](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.argocd](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_service_principal.sp_argocd](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_delegated_permission_grant.argocd_user_read_consent](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_delegated_permission_grant) | resource |
| [azurerm_key_vault_secret.argocd_entra_app_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.argocd_entra_app_service_account_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azuread_group.argocd_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.graph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_users.argocd_application_owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv_core_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_entra_groups_allowed"></a> [argocd\_entra\_groups\_allowed](#input\_argocd\_entra\_groups\_allowed) | Definizione della variabile per i nomi dei gruppi Entra ID | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: weu, weu.. | `string` | n/a | yes |
| <a name="input_location_westeurope"></a> [location\_westeurope](#input\_location\_westeurope) | n/a | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"cstar"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
