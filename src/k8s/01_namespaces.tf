resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "kubernetes_namespace" "dvopla" {
  metadata {
    name = var.prefix
  }
}
