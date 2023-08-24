prefix          = "dvopla"
env_short       = "d"
env             = "dev"
domain          = "grafana"
location        = "northeurope"
location_short  = "neu"
location_string = "North Europe"
instance        = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "PagoPa"
  Source      = "https://github.com/pagopa/cstar-infrastructure/tree/main/src/grafana-monitoring"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "dvopla-d-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-law"
log_analytics_workspace_resource_group_name = "dvopla-d-monitor-rg"

external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.devopslab"
apim_dns_zone_prefix     = "dev.cstar"

# chart releases: https://github.com/pagopa/aks-microservice-chart-blueprint/releases
# image tags: https://github.com/pagopa/infra-ssl-check/releases
tls_cert_check_helm = {
  chart_version = "1.21.0"
  image_name    = "ghcr.io/pagopa/infra-ssl-check"
  image_tag     = "v1.2.2@sha256:22f4b53177cc8891bf10cbd0deb39f60e1cd12877021c3048a01e7738f63e0f9"
}

