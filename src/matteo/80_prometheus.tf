resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "15.10.4"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "alertmanager.enabled"
    value = false
  }

  set {
    name  = "configmapReload.prometheus.enabled"
    value = false
  }

  set {
    name  = "server.global.scrape_interval"
    value = "30s"
  }

  set {
    name  = "kube-state-metrics.image.repository"
    value = "registry.k8s.io/kube-state-metrics/kube-state-metrics"
  }

  set {
    # tag: v2.5.0
    name  = "kube-state-metrics.image.tag@sha256"
    value = "09a36e2be1dbda6009641235d90be8627c9616d42a0b887b770fc92c1753b74a"
  }

  set {
    name  = "nodeExporter.image.repository"
    value = "quay.io/prometheus/node-exporter@sha256"
  }

  set {
    # tag: v1.3.1
    name  = "nodeExporter.image.tag"
    value = "f2269e73124dd0f60a7d19a2ce1264d33d08a985aed0ee6b0b89d0be470592cd"
  }

  set {
    name  = "pushgateway.image.repository"
    value = "prom/pushgateway@sha256"
  }

  set {
    # tag: v1.4.3
    name  = "pushgateway.image.tag"
    value = "3496e0f859434b60e6e6eccbc1dddf33adad9a9eb19592dc4ed4a4bf167a844d"
  }

  set {
    name  = "server.image.repository"
    value = "quay.io/prometheus/prometheus@sha256"
  }

  set {
    # tag: v2.36.2
    name  = "server.image.tag"
    value = "df0cd5887887ec393c1934c36c1977b69ef3693611932c3ddeae8b7a412059b9"
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

