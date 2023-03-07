resource "kubernetes_namespace" "deleteme2" {
  metadata {
    name = "deleteme3"
  }
}

resource "kubernetes_service_v1" "example" {
  metadata {
    name = "terraform-example3"
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
