# general
env_short = "p"
location = "westeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "usrreg"
  Source      = "https://github.com/pagopa/usrreg-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

lock_enable = true

# 🔐 key vault
key_vault_name = "usrreg-u-kv"

# ☁️ networking
cidr_vnet               = ["10.1.0.0/16"]
cidr_subnet_azdoa       = ["10.1.130.0/24"]
cidr_subnet_postgres    = ["10.1.129.0/24"]
cidr_subnet_appgateway  = ["10.1.128.0/24"]
cidr_subnet_apim        = ["10.1.136.0/24"]

# dns
external_domain = "pagopa.it"
dns_zone_prefix = "userregistry"

# azure devops
azdo_sp_tls_cert_enabled = true
enable_azdoa             = true
enable_iac_pipeline      = true

# ❇️ app_gateway
api_gateway_sku_name = "WAF_v2"
api_gateway_sku_tier = "WAF_v2"

app_gateway_api_certificate_name = "api-uat-usrreg-pagopa-it"

# 🗄 postgresql
postgres_sku_name       = "GP_Gen5_2"
postgres_enable_replica = false
postgres_configuration = {
  autovacuum_work_mem         = "-1"
  effective_cache_size        = "655360"
  log_autovacuum_min_duration = "5000"
  log_connections             = "off"
  log_line_prefix             = "%t [%p apps:%a host:%r]: [%l-1] db=%d,user=%u"
  log_temp_files              = "4096"
  maintenance_work_mem        = "524288"
  max_wal_size                = "4096"
  log_connections             = "on"
  log_checkpoints             = "on"
  connection_throttling       = "on"
}
postgres_alerts_enabled = false

#
# 🚀 APP Service container
#
app_service_sku = {
  tier     = "Standard"
  size     = "S1"
  capacity = 1
}

#
# 🗺 APIM
#
apim_publisher_name = "pagoPA SelfCare DEV PROD"
apim_sku            = "Developer_1"
