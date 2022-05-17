# general
env_short      = "d"
env            = "lab"
prefix         = "dvopla"
location       = "northeurope"
location_short = "neu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Lab"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/devopslab-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

lock_enable = false

# 🔐 key vault
key_vault_name    = "dvopla-d-neu-kv"
key_vault_rg_name = "dvopla-d-sec-rg"

# ☁️ networking
cidr_vnet                   = ["10.1.0.0/16"]
cidr_subnet_k8s             = ["10.1.0.0/17"]
cidr_subnet_appgateway      = ["10.1.128.0/24"]
cidr_subnet_postgres        = ["10.1.129.0/24"]
cidr_subnet_azdoa           = ["10.1.130.0/24"]
cidr_subnet_app_docker      = ["10.1.132.0/24"]
cidr_subnet_flex_dbms       = ["10.1.133.0/24"]
cidr_subnet_apim            = ["10.1.136.0/24"]
cidr_subnet_aks_ephemeral   = ["10.1.137.0/24"]
cidr_subnet_appgateway_beta = ["10.1.138.0/24"]


# dns
prod_dns_zone_prefix = "devopslab"
lab_dns_zone_prefix  = "lab.devopslab"
external_domain      = "pagopa.it"

# azure devops
enable_azdoa        = true
enable_iac_pipeline = true

# app_gateway
app_gateway_sku_name              = "Standard_v2"
app_gateway_sku_tier              = "Standard_v2"
app_gateway_alerts_enabled        = false
app_gateway_waf_enabled           = false
app_gateway_api_certificate_name  = "api-devopslab-pagopa-it"
app_gateway_beta_certificate_name = "beta-devopslab-pagopa-it"
app_gw_beta_is_enabled            = false

#
# 🗺 APIM
#
apim_publisher_name                = "PagoPA DevOpsLab LAB"
apim_sku                           = "Developer_1"
apim_api_internal_certificate_name = "api-internal-devopslab-pagopa-it"

#
# ⛴ AKS
#
aks_private_cluster_enabled = false
aks_alerts_enabled          = false
# This is the k8s ingress controller ip. It must be in the aks subnet range.
reverse_proxy_ip        = "10.1.0.250"
aks_max_pods            = 100
aks_enable_auto_scaling = false
aks_node_min_count      = null
aks_node_max_count      = null
aks_vm_size             = "Standard_B2ms"

#
# ⛴ AKS
#
aks_ephemeral_enabled                 = false
aks_ephemeral_private_cluster_enabled = false
aks_ephemeral_alerts_enabled          = false
# This is the k8s ingress controller ip. It must be in the aks subnet range.
aks_ephemeral_reverse_proxy_ip   = "10.1.0.250"
aks_ephemeral_kubernetes_version = "1.23.3"
# aks_ephemeral_system_node_pool = {
#     name = "dvladsysephm"
#     vm_size         = "Standard_B2ms",
#     os_disk_type    = "Managed"
#     os_disk_size_gb = null,
#     node_count_min  = 1,
#     node_count_max  = 3,
#     node_labels     = { node_name: "aks-ephemeral", node_type: "system"},
#     node_tags       = { node_tag_1: "1"}
# }
# aks_ephemeral_user_node_pool = {
#     enabled         = true,
#     name            = "dvladephmusr",
#     vm_size         = "Standard_B2ms",
#     os_disk_type    = "Managed",
#     os_disk_size_gb = null,
#     node_count_min  = 1,
#     node_count_max  = 3,
#     node_labels     = { node_name: "aks-ephemeral-user", node_type: "user"},
#     node_taints     = ["key=value:NoSchedule", "key2=value2:NoSchedule"],
#     node_tags       = { node_tag_1: "1"},
# }
aks_ephemeral_system_node_pool = {
  name            = "dvladephmsys",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-ephemeral-sys", node_type : "system" },
  node_tags       = { node_tag_1 : "1" },
}
aks_ephemeral_user_node_pool = {
  enabled         = true,
  name            = "dvladephmusr",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-ephemeral-user", node_type : "user" },
  node_taints     = ["key=value:NoSchedule", "key2=value2:NoSchedule"],
  node_tags       = { node_tag_1 : "1" },
}
aks_ephemeral_addons = {
  azure_policy                     = true,
  azure_key_vault_secrets_provider = true,
  pod_identity_enabled             = true,
}

#
# Web app docker
#
is_web_app_service_docker_enabled = false


# postgres
postgres_private_endpoint_enabled = false
# postgres_sku_name                      = "B_Gen5_1"
# postgres_public_network_access_enabled = false
# postgres_network_rules = {
#   ip_rules = [
#     "0.0.0.0/0"
#   ]
#   # dblink
#   allow_access_to_azure_services = false
# }

#
# Postgres Flexible
#
pgflex_private_config = {
  enabled    = false
  sku_name   = "GP_Standard_D2ds_v4"
  db_version = "13"
  # Possible values are 32768, 65536, 131072, 262144, 524288, 1048576,
  # 2097152, 4194304, 8388608, 16777216, and 33554432.
  storage_mb                   = 32768
  zone                         = 1
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  private_endpoint_enabled     = true
  pgbouncer_enabled            = true
}

pgflex_private_ha_config = {
  high_availability_enabled = true
  standby_availability_zone = 3
}

pgflex_public_config = {
  enabled    = true
  sku_name   = "B_Standard_B1ms"
  db_version = "13"
  # Possible values are 32768, 65536, 131072, 262144, 524288, 1048576,
  # 2097152, 4194304, 8388608, 16777216, and 33554432.
  storage_mb                   = 32768
  zone                         = 1
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  private_endpoint_enabled     = false
  pgbouncer_enabled            = false
}

pgflex_public_ha_config = {
  high_availability_enabled = false
  standby_availability_zone = 3
}
