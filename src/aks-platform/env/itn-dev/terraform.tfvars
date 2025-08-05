# general
prefix              = "dvopla"
env_short           = "d"
env                 = "dev"
domain              = "dev01"
location            = "italynorth"
location_short      = "itn"
location_westeurope = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/devopslab-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_prefix          = "devopslab"
dns_zone_internal_prefix = "internal.devopslab"

# 🔐 key vault
key_vault_name    = "dvopla-d-neu-kv"
key_vault_rg_name = "dvopla-d-sec-rg"

### Network

cidr_subnet_system_aks = ["10.3.9.0/24"]
cidr_subnet_user_aks   = ["10.3.10.0/24"]

### Aks

#
# ⛴ AKS
#
rg_vnet_italy_name         = "dvopla-d-itn-vnet-rg"
vnet_italy_name            = "dvopla-d-itn-vnet"
public_ip_aksoutbound_name = "dvopla-d-aksoutbound-pip-1"

aks_enabled                 = true
aks_private_cluster_enabled = true
aks_alerts_enabled          = false
aks_kubernetes_version      = "1.32.3"
aks_system_node_pool = {
  name            = "dvldev01sys",
  vm_size         = "Standard_B4ms",
  os_disk_type    = "Managed",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-dev01-sys", node_type : "system" },
  node_tags       = { node_tag_1 : "1" },
}

aks_user_node_pool = {
  enabled         = true,
  name            = "dvldev01usr",
  vm_size         = "Standard_B8ms",
  os_disk_type    = "Managed",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 1,
  node_labels     = { node_name : "aks-dev01-user", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_2 : "2" },
}

aks_spot_user_node_pool = {
  enabled         = false,
  name            = "dvldev01uspo",
  vm_size         = "Standard_D8ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 300,
  node_count_min  = 1,
  node_count_max  = 1,
  node_labels     = { node_name : "aks-spot-dev01-user", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_2 : "2" },
}


# aks_system_node_pool = {
#   name            = "dvlarddev01sys",
#   vm_size         = "Standard_D2ds_v5",
#   os_disk_type    = "Ephemeral",
#   os_disk_size_gb = 75,
#   node_count_min  = 1,
#   node_count_max  = 3,
#   node_labels     = { node_name : "aks-dev01-sys", node_type : "system" },
#   node_tags       = { node_tag_1 : "1" },
# }
# aks_user_node_pool = {
#   enabled         = true,
#   name            = "dvlarddev01usr",
#   vm_size         = "Standard_D2ds_v5",
#   os_disk_type    = "Ephemeral",
#   os_disk_size_gb = 75,
#   node_count_min  = 1,
#   node_count_max  = 3,
#   node_labels     = { node_name : "aks-dev01-user", node_type : "user" },
#   node_taints     = [],
#   node_tags       = { node_tag_2 : "2" },
# }

aks_addons = {
  azure_policy                     = true,
  azure_key_vault_secrets_provider = true,
}

ingress_replica_count = "1"
# This is the k8s ingress controller ip. It must be in the aks subnet range.
ingress_load_balancer_ip = "10.3.10.250"

nginx_helm_version = "4.12.1"
keda_helm_version  = "2.16.1"

# chart releases: https://github.com/stakater/Reloader/releases
# image tags: https://hub.docker.com/r/stakater/reloader/tags
reloader_helm = {
  chart_version = "v1.0.30"
  image_name    = "stakater/reloader"
  image_tag     = "v1.0.30"
}

#
# Argocd
#
# https://github.com/argoproj/argo-helm/releases
argocd_helm_release_version    = "8.2.4" #3.0.5+
argocd_application_namespaces  = ["argocd", "testit", "diego", "keda"]
argocd_force_reinstall_version = "v20250805_1"
