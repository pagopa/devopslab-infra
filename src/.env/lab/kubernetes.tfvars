prefix = "dvopla"

# AKS
aks_private_cluster_enabled = false

# namespace
namespace = "devopslab"

# ingress
nginx_helm_version       = "4.0.12"
ingress_replica_count    = "2"
ingress_load_balancer_ip = "20.67.201.123"

# RBAC
rbac_namespaces_for_deployer_binding = ["devopslab"]

# Gateway
api_gateway_url = "https://api.dev.userregistry.pagopa.it"

# configs/secrets
