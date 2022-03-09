resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "0.0.109"
  namespace  = "helm-template"

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
