prefix = "dvopla"

# AKS
aks_private_cluster_enabled = false
aks_num_outbound_ips        = 1
kubernetes_version          = "1.23.3"
# This is the k8s ingress controller ip. It must be in the aks subnet range.
# aks_reverse_proxy_ip = "10.1.0.250"
aks_system_node_pool = {
  name            = "dvladsys",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-sys", node_type : "system" },
  node_tags       = {},
}
aks_user_node_pool = {
  enabled         = true,
  name            = "dvladusr",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-user", node_type : "user" },
  node_taints     = [],
  node_tags       = {},
}
aks_addons = {
  azure_policy                     = true,
  azure_key_vault_secrets_provider = true,
  pod_identity_enabled             = true,
}

# namespace
namespace = "devopslab"

# ingress
nginx_helm_version       = "4.0.17"
ingress_replica_count    = "2"
ingress_load_balancer_ip = "20.67.201.123"

# RBAC
rbac_namespaces_for_deployer_binding = ["devopslab", "helm-template"]

# Gateway
api_gateway_url = "https://api.dev.userregistry.pagopa.it"

# configs/secrets
