resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }
}

resource "kubernetes_namespace" "platform_namespace" {
  metadata {
    name = var.namespace
  }
}
