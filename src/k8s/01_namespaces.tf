resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "kubernetes_namespace" "usrreg" {
  metadata {
    name = var.prefix
  }
}
