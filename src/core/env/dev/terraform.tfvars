# general
env_short      = "d"
env            = "lab"
prefix         = "dvopla"
domain         = "core"
location       = "northeurope"
location_short = "neu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Lab"
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
cidr_subnet_postgres                  = ["10.1.129.0/24"]
cidr_subnet_azdoa                     = ["10.1.130.0/24"]
cidr_subnet_app_docker                = ["10.1.132.0/24"]
cidr_subnet_flex_dbms                 = ["10.1.133.0/24"]
cidr_subnet_apim                      = ["10.1.136.0/24"]
cidr_subnet_appgateway_beta           = ["10.1.138.0/24"]
cidr_subnet_vpn                       = ["10.1.139.0/24"]
cidr_subnet_dnsforwarder              = ["10.1.140.0/29"]
cidr_subnet_private_endpoints         = ["10.1.141.0/24"]
cidr_subnet_eventhub                  = ["10.1.142.0/24"]
cidr_subnet_redis                     = ["10.1.143.0/24"]
cidr_subnet_funcs_diego_domain        = ["10.1.144.0/24"]
cidr_subnet_app_diego_app             = ["10.1.145.0/24"]
cidr_subnet_github_runner_self_hosted = ["10.1.148.0/23"]
cidr_subnet_container_apps_dapr       = ["10.1.150.0/23"] #placeholder
cidr_subnet_apim_stv2                 = ["10.1.152.0/24"]
cidr_subnet_tools_cae                 = ["10.1.248.0/23"]

### Italy
cidr_vnet_italy = ["10.3.0.0/16"]

cidr_subnet_private_endpoints_italy = ["10.3.251.0/24"]

# azure devops
enable_azdoa        = true
enable_iac_pipeline = true

# VPN
vpn_enabled           = true
dns_forwarder_enabled = true

# app_gateway
app_gateway_is_enabled            = false
app_gateway_sku_name              = "Standard_v2"
app_gateway_sku_tier              = "Standard_v2"
app_gateway_alerts_enabled        = false
app_gateway_waf_enabled           = false
app_gateway_api_certificate_name  = "api-devopslab-pagopa-it"
app_gateway_beta_certificate_name = "beta-devopslab-pagopa-it"
app_gw_beta_is_enabled            = false

#
# 🗺 APIM
#
apim_enabled                       = false
apim_publisher_name                = "PagoPA DevOpsLab LAB"
apim_sku                           = "Premium_1"
apim_api_internal_certificate_name = "api-internal-devopslab-pagopa-it"

apim_subnet_nsg_security_rules = [
  {
    name                       = "inbound-management-3443"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "ApiManagement"
    destination_port_range     = "3443"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "inbound-management-6390"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = "6390"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "inbound-load-balancer"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "outbound-storage-443"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "outbound-sql-1433"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "1433"
    destination_address_prefix = "SQL"
  },
  {
    name                       = "outbound-kv-433"
    priority                   = 220
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "433"
    destination_address_prefix = "AzureKeyVault"
  }
]

# postgres
postgres_private_endpoint_enabled      = false
postgres_public_network_access_enabled = false
postgres_network_rules = {
  ip_rules = [
    "0.0.0.0/0"
  ]
  # dblink
  allow_access_to_azure_services = false
}

#
# Redis
#
redis_enabled = false


law_daily_quota_gb = 1

azdoa_image_name = "azdo-agent-ubuntu2204-image-velero-v1"

#
# Container app ENV
#
container_app_tools_cae_env_rg = "dvopla-d-neu-tools-cae"

#
# Feature Flags
#
is_resource_core_enabled = {
  postgresql_server = false
}
