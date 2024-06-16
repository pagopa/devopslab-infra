# general
prefix         = "dvopla"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "testit"
instance       = "dev01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "devops"
  Source      = "https://github.com/pagopa/dvopla-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "testit.app"
}

is_feature_enabled = {
  nodepool_dedicated      = false
}

#
# Network
#
rg_vnet_italy_name         = "dvopla-d-itn-vnet-rg"
vnet_italy_name            = "dvopla-d-itn-vnet"
cidr_subnet_user_aks_testit = ["10.3.123.0/24"]

### External resources
monitor_resource_group_name                 = "dvopla-d-itn-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-itn-law"
log_analytics_workspace_resource_group_name = "dvopla-d-itn-monitor-rg"


### Aks

aks_name                = "dvopla-d-itn-dev-aks"
aks_resource_group_name = "dvopla-d-itn-dev-aks-rg"

ingress_load_balancer_ip       = "10.3.10.250"
ingress_load_balancer_hostname = "testit.itn.internal.devopslab.pagopa.it"

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_prefix          = "devopslab"
dns_zone_internal_prefix = "internal.devopslab"

#
# TLS Checker
#
# chart releases: https://github.com/pagopa/aks-microservice-chart-blueprint/releases
# image tags: https://github.com/pagopa/infra-ssl-check/releases
tls_cert_check_helm = {
  chart_version = "1.21.0"
  image_name    = "ghcr.io/pagopa/infra-ssl-check"
  image_tag     = "v1.2.2@sha256:22f4b53177cc8891bf10cbd0deb39f60e1cd12877021c3048a01e7738f63e0f9"
}

aks_user_node_pool_testit = {
  name            = "dvldtestit",
  vm_size         = "Standard_B8ms",
  os_disk_type    = "Managed",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 1,
  node_labels     = { node_name : "devopslab-dev-testit-user", node_type : "user", domain : "testit" },
  node_taints     = ["paymentWalletOnly=true:NoSchedule"],
  node_tags       = { payWallet : "user" },
}
