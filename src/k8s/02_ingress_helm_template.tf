resource "kubernetes_ingress" "helm_template_ingress" {
  depends_on = [module.nginx_ingress]

  metadata {
    name      = "${kubernetes_namespace.helm_template.metadata[0].name}-ingress"
    namespace = kubernetes_namespace.helm_template.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/$1"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/use-regex"          = "true"
    }
  }

  spec {
    tls {
      hosts       = ["helm-template.ingress.devopslab.pagopa.it"]
      secret_name = "ingress-tls"
    }

    rule {
      host = "helm-template.ingress.devopslab.pagopa.it"
      http {
        path {
          backend {
            service_name = "templatemicroserviziok8s-microservice-chart"
            service_port = 80
          }
          path = "/(.*)"
        }
      }
    }
  }
}
