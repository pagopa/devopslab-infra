# general
prefix         = "dvopla"
env_short      = "d"
env            = "dev"
location       = "northeurope"
location_short = "neu"
domain         = "packer"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "devops"
  Source      = "https://github.com/pagopa/dvopla-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "marco.common"
}

dns_forwarder_image_version = "v1"
