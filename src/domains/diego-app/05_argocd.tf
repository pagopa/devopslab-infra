#
# Terraform argocd project
#
resource "kubernetes_manifest" "argocd_project_terraform" {
  manifest = yamldecode(templatefile("${path.module}/argocd/projects/project-terraform-argocd.yaml", {}))
  field_manager {
    # set the name of the field manager
    name = "argocd"

    # force field manager conflicts to be overridden
    force_conflicts = true
  }
}

data "kubernetes_secret_v1" "example" {
  metadata {
    name      = "example-secret"
    namespace = "argocd"
  }
  binary_data = {
    "keystore.p12" = ""
    another_field  = ""
  }
}

$2a$10$spTFkPoQd.spcen9xT1tq.aMJ4O9fgH6q.r9c2sLLmwYIMWvgRyw.

$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)


resource "null_resource" "argocd_create_app" {
  provisioner "local-exec" {
    command = "argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse
"
  }
}


#
# APPS Diego deploy
#
resource "kubernetes_manifest" "argocd_app_diego" {
  manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-diego.yaml", {
    NAME: "domain-diego-deploy"
    ARGOCD_PROJECT_NAME: "terraform-argocd-project"
    WORKLOAD_IDENTITY_CLIENT_ID: module.workload_identity.workload_identity_client_id
    GIT_REPO_URL: "https://github.com/diegolagospagopa/devopslab-diego-deploy"
    GIT_TARGET_REVISION: "init-charts"
    HELM_PATH: "helm/dev"
    NAMESPACE: var.domain
    DOMAIN: var.domain
  }))
}


#
# APPS Showcase
#
resource "kubernetes_manifest" "argocd_app_status_standalone" {
  count = var.argocd_showcase_enabled ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/argocd/apps/app-status-standalone.yaml", {}))
}

resource "kubernetes_manifest" "argocd_apps_ok" {
  count = var.argocd_showcase_enabled ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-ok.yaml", {}))
}

resource "kubernetes_manifest" "argocd_broken_apps" {
  count = var.argocd_showcase_enabled ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/argocd/apps/apps-terraform-broken.yaml", {}))
}
