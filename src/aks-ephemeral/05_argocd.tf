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
  chart      = "https://github.com/argoproj/argo-helm/releases/download/argo-cd-4.6.3/argo-cd-4.6.3.tgz"
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
