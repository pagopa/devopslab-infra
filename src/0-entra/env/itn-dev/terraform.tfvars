# general
prefix              = "dvopla"
env_short           = "d"
env                 = "dev"
domain              = "entra"
location            = "italynorth"
location_short      = "itn"
location_westeurope = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/devopslab-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}


argocd_entra_groups_allowed = ["dvopla-d-adgroup-admin", "dvopla-d-adgroup-developers", "dvopla-d-adgroup-externals"]
