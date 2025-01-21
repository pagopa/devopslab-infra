resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      "name" = "cert-manager"
    }
  }
}

# Install cert-manager with CRDs
resource "helm_release" "cert_manager_setup" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  version          = "v1.16.3"
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  # Attendiamo che i webhook siano pronti
  set {
    name  = "webhook.timeoutSeconds"
    value = "30"
  }
}
