locals {
  project_name2 = "${var.domain}-project-2"
}

#
# Terraform argocd project
#
resource "argocd_project" "argocd_project_diego2" {
  metadata {
    name      = local.project_name2 # e.g. "diego-project"
    namespace = "argocd"

    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = local.project_name2

    # solo manifest provenienti dal repo naming-convention del dominio
    source_namespaces = [var.domain]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }

    # ───────────────────────────────────────────────────────────────
    # Hardening: impedisci operazioni sui Namespace a livello cluster
    # ───────────────────────────────────────────────────────────────
    cluster_resource_blacklist {
      group = ""
      kind  = "Namespace"
    }

    # puoi restringere più avanti questi due wildcard
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

    # ──────────────── Project-scoped ROLES ─────────────────────────

    role {
      name   = "admin"
      groups = []
      policies = [
        "p, proj:${local.project_name2}:admin, applications, *, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:admin, applicationsets, *, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:admin, logs, get, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:admin, exec, create, ${local.project_name2}/*, allow",
      ]
    }

    role {
      name   = "developer"
      groups = [] # popola con i group objectId Entra ID
      policies = [
        "p, proj:${local.project_name2}:developer, applications, get, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:developer, applications, create, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:developer, applications, update, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:developer, applications, delete, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:developer, applications, sync, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:developer, applicationsets, *, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:developer, logs, get, ${local.project_name2}/*, allow",
      ]
    }

    role {
      name   = "reader"
      groups = [] # popola con i group objectId Entra ID
      policies = [
        "p, proj:${local.project_name2}:reader, applications, get, ${local.project_name2}/*, allow",
        "p, proj:${local.project_name2}:reader, logs, get, ${local.project_name2}/*, allow",
      ]
    }
  }
}


resource "argocd_application" "diego_applications2" {
  for_each = local.flattened_applications

  metadata {
    name      = "${each.value.name}-2"
    namespace = var.domain
    labels = {
      name   = each.value.name
      domain = var.domain
      class  = each.value.class
      area   = var.domain
    }
  }

  spec {
    project = argocd_project.argocd_project_diego2.metadata[0].name

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }

    source {
      repo_url        = "https://github.com/pagopa/devopslab-diego-deploy"
      target_revision = each.value.target_branch
      path            = "helm/${var.env}/${each.value.class}/${each.value.name}"

      helm {
        values = yamlencode({
          microservice-chart : {
            azure : {
              workloadIdentityClientId : module.workload_identity.workload_identity_client_id
            }
            serviceAccount : {
              name : module.workload_identity.workload_identity_service_account_name
            }
          }
        })
        ignore_missing_value_files = false
        pass_credentials           = false
        skip_crds                  = false
        value_files                = []
      }
    }

    # Sync policy configuration
    sync_policy {

      # sync_options = []
      #
      automated {
        allow_empty = false
        prune       = false
        self_heal   = false
      }
      #
      # retry {
      #   limit = "5"
      #
      #   backoff {
      #     duration     = "5s"
      #     factor       = "2"
      #     max_duration = "3m0s"
      #   }
      # }
    }

    ignore_difference {
      group         = "apps"
      kind          = "Deployment"
      json_pointers = ["/spec/replicas"]
    }
  }
}
