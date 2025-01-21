# Create namespace for kube-green
resource "kubernetes_namespace" "kube_green" {
  metadata {
    name = "kube-green"
  }
}

# Add the kube-green Helm repository
resource "helm_release" "kube_green_setup" {
  depends_on = [helm_release.cert_manager_setup]

  name             = "kube-green"
  repository       = "https://kube-green.github.io/helm-charts"
  chart            = "kube-green"
  namespace        = kubernetes_namespace.kube_green.metadata[0].name
  create_namespace = false
  version          = "0.7.0"  # Specify the version you want to use

  # Basic configuration values
  set {
    name  = "replicaCount"
    value = "1"
  }

  # Configure RBAC
  set {
    name  = "rbac.create"
    value = "true"
  }

  # Configure service account
  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  # Optional: Configure resources
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }
  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }
  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }

  # Optional: Configure metrics
  set {
    name  = "metrics.enabled"
    value = "true"
  }
}

resource "kubernetes_manifest" "sleepinfo_namespaces" {
  depends_on = [helm_release.kube_green_setup]
  for_each = toset(local.sleeping_namespace)

  manifest = {
    apiVersion = "kube-green.com/v1alpha1"
    kind       = "SleepInfo"
    metadata = {
      name      = "${each.key}-sleep-night"
      namespace = each.key  # Lo rimettiamo nel namespace target
    }
    spec = {
      weekdays        = "*"
      sleepAt         = "10:00"
      wakeUpAt        = "06:00"
      timeZone        = "Europe/Rome"
      excludeRef = [
        {
          apiVersion = "apps/v1"
          kind       = "Deployment"
          name       = "critical-app"
        }
      ]
    }
  }
}

# Outputs for verification
output "kube_green_status" {
  description = "Status of kube-green installation"
  value       = helm_release.kube_green_setup.status
}
