prefix          = "dvopla"
env_short       = "d"
env             = "dev"
domain          = "elk"
location        = "northeurope"
location_short  = "neu"
location_string = "North Europe"
instance        = "dev01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "devopslab"
  Source      = "https://github.com/pagopa/devopslab-infra/tree/main/src/domains/elk-monitoring"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "dvopla-d-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-law"
log_analytics_workspace_resource_group_name = "dvopla-d-monitor-rg"

external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.devopslab"
apim_dns_zone_prefix     = "devopslab"

# chart releases: https://github.com/pagopa/aks-microservice-chart-blueprint/releases
# image tags: https://github.com/pagopa/infra-ssl-check/releases
tls_cert_check_helm = {
  chart_version = "1.21.0"
  image_name    = "ghcr.io/pagopa/infra-ssl-check"
  image_tag     = "v1.2.2@sha256:22f4b53177cc8891bf10cbd0deb39f60e1cd12877021c3048a01e7738f63e0f9"
}

elastic_node_pool = {
  enabled         = true
  name            = "elastic01"
  vm_size         = "Standard_B8ms"
  os_disk_type    = "Managed"
  os_disk_size_gb = "300"
  node_count_min  = "1" #TODO change to 2 or 3 in prod
  node_count_max  = "1"
  node_labels = {
    elastic : "eck",
  },
  node_taints           = [],
  node_tags             = { elastic : "yes" },
  elastic_pool_max_pods = "250",
}

elastic_hot_storage = {
  storage_type           = "StandardSSD_ZRS"
  allow_volume_expansion = true
  initialStorageSize     = "16Gi"
}
elastic_warm_storage = {
  storage_type           = "StandardSSD_ZRS"
  allow_volume_expansion = true
  initialStorageSize     = "16Gi"
}
elastic_cold_storage = {
  storage_type           = "Standard_LRS"
  allow_volume_expansion = true
  initialStorageSize     = "16Gi"
}

enable_iac_pipeline = true

subscription_name = "devopslab"

ingress_min_replica_count    = "1"
ingress_max_replica_count    = "3"
ingress_elk_load_balancer_ip = "10.11.100.251"
# ingress-nginx helm charts releases 4.X.X: https://github.com/kubernetes/ingress-nginx/releases?expanded=true&page=1&q=tag%3Ahelm-chart-4
# Pinned versions from "4.7.1" release: https://github.com/kubernetes/ingress-nginx/blob/helm-chart-4.7.1/charts/ingress-nginx/values.yaml
nginx_helm = {
  version = "4.7.1"
  controller = {
    image = {
      registry     = "k8s.gcr.io"
      image        = "ingress-nginx/controller"
      tag          = "v1.8.1"
      digest       = "sha256:e5c4824e7375fcf2a393e1c03c293b69759af37a9ca6abdb91b13d78a93da8bd"
      digestchroot = "sha256:fb17f1700b77d4fcc52ca6f83ffc2821861ae887dbb87149cf5cbc52bea425e5"
    },
    config = {
      proxy-body-size : 0,
    }
  }
}

nodeset_config = {
  balancer-nodes = {
    count            = "1"
    roles            = []
    storage          = "5Gi"
    storageClassName = "dvopla-d-neu-elk-elastic-aks-storage-hot"
  },
  master-nodes = {
    count            = "1"
    roles            = ["master"]
    storage          = "5Gi"
    storageClassName = "dvopla-d-neu-elk-elastic-aks-storage-hot"
  },
  data-hot-nodes = {
    count            = "1"
    roles            = ["ingest", "data_content", "data_hot"]
    storage          = "10Gi"
    storageClassName = "dvopla-d-neu-elk-elastic-aks-storage-hot"
  },
  data-warm-nodes = {
    count            = "1"
    roles            = ["ingest", "data_content", "data_warm"]
    storage          = "10Gi"
    storageClassName = "dvopla-d-neu-elk-elastic-aks-storage-warm"
  },
  data-cold-nodes = {
    count            = "1"
    roles            = ["ingest", "data_content", "data_cold", "data_frozen", "ml", "transform", "remote_cluster_client"]
    storage          = "10Gi"
    storageClassName = "dvopla-d-neu-elk-elastic-aks-storage-cold"
  }
}

opentelemetry_operator_helm = {
  chart_version = "0.24.3"
  values_file   = "./env/opentelemetry_operator_helm/values.yaml"
}
