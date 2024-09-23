#
# Terraform argocd project
#
resource "argocd_project" "myproject" {
  metadata {
    name      = "${var.domain}-project"
    namespace = "argocd"
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = "${var.domain}-project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }

#     cluster_resource_blacklist {
#       group = "*"
#       kind  = "*"
#     }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }

#     role {
#       name = "anotherrole"
#       policies = [
#         "p, proj:myproject:testrole, applications, get, myproject/*, allow",
#         "p, proj:myproject:testrole, applications, sync, myproject/*, deny",
#       ]
#     }
  }
}



#
# #
# # APPS Diego deploy
# #
# resource "kubernetes_manifest" "argocd_app_diego" {
#   manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-diego.yaml", {
#     NAME : "domain-diego-deploy"
#     ARGOCD_PROJECT_NAME : "terraform-argocd-project"
#     WORKLOAD_IDENTITY_CLIENT_ID : module.workload_identity.workload_identity_client_id
#     GIT_REPO_URL : "https://github.com/diegolagospagopa/devopslab-diego-deploy"
#     GIT_TARGET_REVISION : "init-charts"
#     HELM_PATH : "helm/dev"
#     NAMESPACE : var.domain
#     DOMAIN : var.domain
#   }))
# }
#
#
# #
# # APPS Showcase
# #
# resource "kubernetes_manifest" "argocd_app_status_standalone" {
#   count    = var.argocd_showcase_enabled ? 1 : 0
#   manifest = yamldecode(templatefile("${path.module}/argocd/apps/app-status-standalone.yaml", {}))
# }
#
# resource "kubernetes_manifest" "argocd_apps_ok" {
#   count    = var.argocd_showcase_enabled ? 1 : 0
#   manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-ok.yaml", {}))
# }
#
# resource "kubernetes_manifest" "argocd_broken_apps" {
#   count    = var.argocd_showcase_enabled ? 1 : 0
#   manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-broken.yaml", {}))
# }
