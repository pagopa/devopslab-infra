# general
prefix         = "dvopla"
env_short      = "d"
env            = "dev"
location       = "northeurope"
location_short = "neu"
domain         = "diego"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "devops"
  Source      = "https://github.com/pagopa/dvopla-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "diego.app"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "dvopladstinfraterraform"
  container_name       = "corestate"
  key                  = "terraform.tfstate"
}

cidr_subnet_funcs_diego_domain = ["10.1.144.0/24"]
cidr_subnet_app_diego_app      = ["10.1.145.0/24"]

### External resources

monitor_resource_group_name                 = "dvopla-d-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-law"
log_analytics_workspace_resource_group_name = "dvopla-d-monitor-rg"

### Aks

aks_name                = "dvopla-d-neu-dev01-aks"
aks_resource_group_name = "dvopla-d-neu-dev01-aks-rg"

ingress_load_balancer_ip = "10.11.100.250"
# ingress_load_balancer_hostname = "dev01.diego.internal.devopslab.pagopa.it"

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_prefix          = "devopslab"
dns_zone_internal_prefix = "internal.devopslab"

# Function

function_python_diego_enabled = false

#
# App service
#
app_service_plan_enabled         = true
app_service_diego_app_is_enabled = true
