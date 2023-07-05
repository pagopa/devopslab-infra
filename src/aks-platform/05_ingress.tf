resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }

  depends_on = [
    module.aks
  ]
}

# from Microsoft docs https://docs.microsoft.com/it-it/azure/aks/ingress-internal-ip
module "nginx_ingress" {
  source  = "terraform-module/release/helm"
  version = "2.7.0"

  namespace  = kubernetes_namespace.ingress.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  app = {
    name          = "nginx-ingress"
    wait          = false
    version       = var.nginx_helm_version
    chart         = "ingress-nginx"
    recreate_pods = true #https://github.com/helm/helm/issues/6378 -> fixed in k8s 1.22
    deploy        = 1
  }

  values = [
    templatefile("${path.module}/ingress/loadbalancer.yaml.tpl", { load_balancer_ip = var.ingress_load_balancer_ip }),
    yamlencode({
      controller = {
        replicaCount = var.ingress_replica_count
        nodeSelector = {
          "beta.kubernetes.io/os" = "linux"
        }
        admissionWebhooks = {
          patch = {
            nodeSelector = {
              "beta.kubernetes.io/os" = "linux"
            }
          }
        }
        ingressClassResource = {
          enabled = true
          default = true
          name    = "nginx"
        }
        # image = {
        #   repository = "k8s.gcr.io/ingress-nginx/controller"
        #   tag        = "v1.8.1" // new version to test
        # }
      }
      defaultBackend = {
        nodeSelector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    })

  ]

  depends_on = [
    module.aks
  ]
}
