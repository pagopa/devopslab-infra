resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = "2.6.0"
  namespace  = kubernetes_namespace.keda.metadata[0].name
}
