resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "15.10.4"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "server.global.scrape_interval"
    value = "30s"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "6.32.3"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "adminUser"
    value = data.azurerm_key_vault_secret.grafana_admin_username.value
  }

  set {
    name  = "adminPassword"
    value = data.azurerm_key_vault_secret.grafana_admin_password.value
  }
}

