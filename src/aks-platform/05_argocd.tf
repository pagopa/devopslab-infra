resource "kubernetes_namespace" "namespace_argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [
    module.aks
  ]
}

resource "kubernetes_namespace" "namespace_games" {
  metadata {
    name = "games"
  }

  depends_on = [
    module.aks
  ]
}

resource "helm_release" "argocd" {
  name       = "argo"
  chart      = "https://github.com/argoproj/argo-helm/releases/download/argo-cd-5.53.0/argo-cd-5.53.0.tgz"
  namespace  = kubernetes_namespace.namespace_argocd.metadata[0].name
  wait       = false

  values = [
    "${file("argocd/argocd_helm_setup_values.yaml")}"
  ]

  depends_on = [
    module.aks
  ]
}

#
# Project
#
resource "kubectl_manifest" "argocd_project_games" {
    yaml_body = templatefile("argocd/argocd_project_games.yaml.tpl", {
            project_name: "games",
            deployment_repo_url: "https://github.com/pagopa/devopslab-argocd",
            namespace: "games"
        })
}

#
# Applications ArgoCD
#
resource "kubectl_manifest" "argocd_app_games" {
    yaml_body = templatefile("argocd/argocd_application_games.yaml.tpl", {
            project_name: "games",
            deployment_repo_url: "https://github.com/pagopa/devopslab-argocd",
            target_revision: "release-dev"
            namespace: "games"
        })
}

#
# tools
#

module "domain_pod_identity" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_pod_identity?ref=v7.7.0"

  cluster_name        = local.aks_cluster_name
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = var.location
  tenant_id           = data.azurerm_subscription.current.tenant_id

  identity_name = "argocd-pod-identity"
  namespace     = kubernetes_namespace.namespace_argocd.metadata[0].name
  key_vault_id  = data.azurerm_key_vault.kv_core.id

  secret_permissions      = ["Get"]
  certificate_permissions = ["Get"]
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = kubernetes_namespace.namespace_argocd.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}

module "cert_mounter" {
  source           = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v7.52.0"
  namespace        = "argocd"
  certificate_name = replace(local.argocd_internal_url, ".", "-")
  kv_name          = data.azurerm_key_vault.kv_core.name
  tenant_id        = data.azurerm_subscription.current.tenant_id
}
