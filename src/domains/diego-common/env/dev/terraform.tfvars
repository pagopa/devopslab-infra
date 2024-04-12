# general
prefix         = "dvopla"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "diego"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "devops"
  Source      = "https://github.com/pagopa/dvopla-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "diego.common"
}

lock_enable = true

cidr_subnet_funcs_diego_domain = ["10.1.144.0/24"]

is_feature_enabled = {
  cdn = false
}

### External resources
monitor_resource_group_name                 = "dvopla-d-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-law"
log_analytics_workspace_resource_group_name = "dvopla-d-monitor-rg"

storage_management_policy_rules = [
  {
    name : "rule1"
    enabled : true
    filters : {

    }
  }
]
