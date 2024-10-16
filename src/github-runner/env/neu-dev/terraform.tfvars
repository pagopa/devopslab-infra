prefix         = "dvopla"
env_short      = "d"
env            = "dev"
location       = "northeurope"
location_short = "neu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/devopslab-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

key_vault_common = {
  name            = ""
  pat_secret_name = "github-runner-pat"
}

networking = {
  vnet_common_name  = "dvopla-d-vnet"
  subnet_cidr_block = "10.1.148.0/23"
}

law_name = "dvopla-d-law"
