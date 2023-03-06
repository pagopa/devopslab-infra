resource "kubernetes_namespace" "deleteme2" {
  metadata {
    name = "deleteme2"
  }
}

resource "kubernetes_service_v1" "example" {
  metadata {
    name = "terraform-example2"
    namespace  = kubernetes_namespace.domain_namespace.metadata[0].name
  }
  spec {
    selector = {
      app = "ciao"
    }
    port {
      port        = 8080
      target_port = 80
    }

    type = "ClusterIP"
  }
}
