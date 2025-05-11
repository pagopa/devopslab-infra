# general
env_short      = "d"
env            = "dev"
prefix         = "dvopla"
domain         = "core"
location       = "italynorth"
location_short = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/devopslab-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

lock_enable = false

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_prefix          = "devopslab"
dns_zone_internal_prefix = "internal.devopslab"

### Italy
cidr_vnet_italy = ["10.3.0.0/16"]

cidr_subnet_vpn = ["10.3.2.0/24"]

cidr_subnet_dnsforwarder_lb   = ["10.3.200.0/29"]
cidr_subnet_dnsforwarder_vmss = ["10.3.200.8/29"]

cidr_subnet_packer_azdo          = ["10.3.254.0/28"]
cidr_subnet_packer_dns_forwarder = ["10.3.254.16/28"]

# VPN
vpn_sku     = "VpnGw1"
vpn_pip_sku = "Standard"


dns_forwarder_vmss_image_version = "v20250214"
