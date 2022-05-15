# general
prefix         = "dvopla"
env_short      = "d"
env            = "dev"
domain         = "dev"
location       = "northeurope"
location_short = "neu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/devopslab-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "dvopladstinfraterraform"
  container_name       = "corestate"
  key                  = "terraform.tfstate"
}

### Network

aks_cidr_subnet = ["10.1.0.0/17"]

### External resources

monitor_resource_group_name                 = "dvopla-d-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-law"
log_analytics_workspace_resource_group_name = "dvopla-d-monitor-rg"

### Aks

aks_sku_tier = "Free"
aks_private_cluster_is_enabled = false

aks_system_node_pool = {
  name                         = "system01"
  vm_size                      = "Standard_D2ds_v5"
  os_disk_type                 = "Ephemeral"
  os_disk_size_gb              = "75"
  node_count_min               = "1" #TODO change to 2 or 3 in prod
  node_count_max               = "3"
  only_critical_addons_enabled = true
  node_labels                  = { node_name : "aks-system-01", node_type : "system" },
  node_tags                    = { node_tag_1 : "1" },
}

aks_user_node_pool = {
  enabled         = true
  name            = "user01"
  vm_size         = "Standard_D8ds_v5"
  os_disk_type    = "Ephemeral"
  os_disk_size_gb = "300"
  node_count_min  = "0" #TODO change to 2 or 3 in prod
  node_count_max  = "3"
  node_labels     = { node_name : "aks-user-01", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_1 : "1" },
}


ingress_replica_count    = "2"
ingress_load_balancer_ip = "10.1.100.250"
nginx_helm_version       = "4.1.0"
keda_helm_version        = "2.6.2"
