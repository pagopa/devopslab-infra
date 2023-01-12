# general
prefix         = "dvopla"
env_short      = "d"
env            = "lab"
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
  Application = "IdPay"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "dvopladstinfraterraform"
  container_name       = "corestate"
  key                  = "terraform.tfstate"
}

cidr_subnet_funcs_diego_domain             = ["10.1.144.0/24"]

### External resources

monitor_resource_group_name                 = "dvopla-d-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-law"
log_analytics_workspace_resource_group_name = "dvopla-d-monitor-rg"
