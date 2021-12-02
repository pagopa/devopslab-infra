prefix = "usrreg"

# ingress
nginx_helm_version       = "4.0.12"
ingress_replica_count    = "2"
ingress_load_balancer_ip = "20.82.206.96"

# RBAC
rbac_namespaces_for_deployer_binding = ["usrreg"]

# Gateway
api_gateway_url = "https://api.uat.userregistry.pagopa.it"

# configs/secrets
