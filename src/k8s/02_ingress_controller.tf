# from Microsoft docs https://docs.microsoft.com/it-it/azure/aks/ingress-internal-ip
module "nginx_ingress" {
  source  = "terraform-module/release/helm"
  version = "2.7.0"

  namespace  = kubernetes_namespace.ingress.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  app = {
    name          = "nginx-ingress"
    version       = var.nginx_helm_version
    chart         = "ingress-nginx"
    recreate_pods = false #https://github.com/helm/helm/issues/6378 -> fixed in k8s 1.22
    deploy        = 1
  }

  values = [
    "${templatefile(
      "${path.module}/ingress/loadbalancer.yaml.tpl",
      {
        load_balancer_ip         = data.azurerm_public_ip.aks_pip.ip_address
        is_load_balancer_private = var.aks_private_cluster_enabled
        vnet_resource_group_name = local.vnet_resource_group_name
      }
    )}",
    templatefile(
      "${path.module}/ingress/autoscaling.yaml.tpl",
      {
        min_replicas = 1
        max_replicas = 4
        triggers = [
          {
            type = "azure-monitor"
            metadata = {
              tenantId              = data.azurerm_subscription.current.tenant_id
              subscriptionId        = data.azurerm_subscription.current.subscription_id
              resourceGroupName     = "dvopla-d-sec-rg"
              resourceURI           = "Microsoft.KeyVault/vaults/dvopla-d-neu-kv"
              metricName            = "ServiceApiHit"
              metricAggregationType = "Count"
              targetValue           = "30"
            }
            authenticationRef = {
              name = "ingress-keda-trigger-authentication"
            }
          }
        ]
      }
    ),
  ]

  set = [
    {
      name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
      value = "linux"
    },
    {
      name  = "defaultBackend.nodeSelector.beta\\.kubernetes\\.io/os"
      value = "linux"
    },
    {
      name  = "controller.admissionWebhooks.patch.nodeSelector.beta\\.kubernetes\\.io/os"
      value = "linux"
    }
  ]
}

resource "kubernetes_manifest" "ingress_keda_trigger_authentication" {
  manifest = {
    "apiVersion" = "keda.sh/v1alpha1"
    "kind"       = "TriggerAuthentication"
    "metadata" = {
      "name"      = "ingress-keda-trigger-authentication"
      "namespace" = kubernetes_namespace.ingress.metadata[0].name
    }
    "spec" = {
      "podIdentity" = {
        "provider" = "azure"
      }
    }
  }
}
