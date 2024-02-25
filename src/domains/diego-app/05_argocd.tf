#
# Terraform argocd project
#
resource "kubernetes_manifest" "argocd_project_terraform" {
  manifest = yamldecode(templatefile("${path.module}/argocd/projects/project-terraform-argocd.yaml", {}))
}

#
# APPS
#
resource "kubernetes_manifest" "argocd_app_status_standalone" {
  manifest = yamldecode(templatefile("${path.module}/argocd/apps/app-status-standalone.yaml", {}))
}

resource "kubernetes_manifest" "argocd_apps_ok" {
  manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-ok.yaml", {}))
}

resource "kubernetes_manifest" "argocd_broken_apps" {
  manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-broken.yaml", {}))
}

