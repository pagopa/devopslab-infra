# general
prefix         = "dvopla"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "testcenter"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "devops"
  Source      = "https://github.com/pagopa/dvopla-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "testcenter.common"
}

lock_enable = true

### External resources
monitor_resource_group_name                 = "dvopla-d-itn-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-itn-law"
log_analytics_workspace_resource_group_name = "dvopla-d-itn-monitor-rg"
