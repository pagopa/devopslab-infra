# general
env_short          = "d"
env                = "dev"
prefix             = "dvopla"
domain             = "core"
location           = "northeurope"
location_short     = "neu"
location_ita       = "italynorth"
location_short_ita = "itn"

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

# 🔐 key vault
key_vault_name    = "dvopla-d-neu-kv"
key_vault_rg_name = "dvopla-d-sec-rg"

# ☁️ networking
cidr_vnet                             = ["10.1.0.0/16"]
cidr_subnet_appgateway                = ["10.1.128.0/24"]
cidr_subnet_app_docker                = ["10.1.132.0/24"]
cidr_subnet_flex_dbms                 = ["10.1.133.0/24"]
cidr_subnet_appgateway_beta           = ["10.1.138.0/24"]
cidr_subnet_private_endpoints         = ["10.1.141.0/24"]
cidr_subnet_eventhub                  = ["10.1.142.0/24"]
cidr_subnet_funcs_diego_domain        = ["10.1.144.0/24"]
cidr_subnet_app_diego_app             = ["10.1.145.0/24"]
cidr_subnet_github_runner_self_hosted = ["10.1.148.0/23"]
cidr_subnet_container_apps_dapr       = ["10.1.150.0/23"] #placeholder
cidr_subnet_apim_stv2                 = ["10.1.152.0/24"]

### Italy
cidr_vnet_italy = ["10.3.0.0/16"]

cidr_subnet_vpn      = ["10.3.2.0/24"]

cidr_subnet_dnsforwarder_lb   = ["10.3.200.0/29"]
cidr_subnet_dnsforwarder_vmss = ["10.3.200.8/29"]

# azure devops
enable_azdoa        = true
enable_iac_pipeline = true

# VPN
vpn_enabled           = true
dns_forwarder_enabled = true
vpn_sku               = "VpnGw1"
vpn_pip_sku           = "Standard"


dns_forwarder_vmss_image_version = "v20250214"


