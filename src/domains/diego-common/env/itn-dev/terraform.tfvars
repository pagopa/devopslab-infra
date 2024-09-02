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


is_feature_enabled = {
  cdn = false
}

### External resources
monitor_resource_group_name                 = "dvopla-d-itn-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-itn-law"
log_analytics_workspace_resource_group_name = "dvopla-d-itn-monitor-rg"

aks_name = "dvopla-d-itn-dev-aks"
aks_resource_group_name = "dvopla-d-itn-dev-aks-rg"

storage_management_policy_rules = [
  {
    name : "rule1"
    enabled : true
    filters : {

    }
  }
]
