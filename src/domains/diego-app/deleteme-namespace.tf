resource "kubernetes_namespace" "deleteme" {
  metadata {
    name = "deleteme"
  }
}
