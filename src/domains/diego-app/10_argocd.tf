locals {
  project_blue_name = "blue-${var.domain}-project"
}

#
# Terraform argocd project
#
resource "argocd_project" "argocd_project_diego_blue" {
  metadata {
    name      = local.project_blue_name
    namespace = "argocd"
    labels = { acceptance = "true" }
  }

  spec {
    description       = local.project_blue_name
    source_namespaces = [var.domain]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }

    # ───────────────── Security Guards ─────────────────
    cluster_resource_blacklist {
      group = ""
      kind  = "Namespace"
    }

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

    # ──────────────────── ROLES ───────────────────────
    # Admin → pieno controllo + modifica AppProject
    role {
      name   = "admin"
      groups = []
      policies = [
        "p, proj:${local.project_blue_name}:admin, applications, *, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:admin, applicationsets, *, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:admin, logs, get, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:admin, exec, create, ${local.project_blue_name}/*, allow",
      ]
    }

    role {
      name   = "developer"
      groups = []
      policies = [
        "p, proj:${local.project_blue_name}:developer, applications, get, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:developer, applications, create, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:developer, applications, update, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:developer, applications, delete, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:developer, applications, sync, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:developer, applicationsets, *, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:developer, logs, get, ${local.project_blue_name}/*, allow",
      ]
    }

    role {
      name   = "reader"
      groups = []
      policies = [
        "p, proj:${local.project_blue_name}:reader, applications, get, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:reader, logs, get, ${local.project_blue_name}/*, allow",
      ]
    }

    role {
      name   = "external"
      groups = [data.azuread_group.adgroup_externals.id]
      policies = [
        "p, proj:${local.project_blue_name}:external, applications, get, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:external, logs, get, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:external, applications, delete/*/Pod/*/*, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:external, applications, action/apps/Deployment/restart, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:external, applications, action/apps/StatefulSet/restart, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:external, applications, action/apps/DaemonSet/restart, ${local.project_blue_name}/*, allow",
        "p, proj:${local.project_blue_name}:external, applications, sync, ${local.project_blue_name}/*, allow",
      ]
    }
  }
}

locals {
  argocd_applications = {
    "top" = {
      "one-color" = {
        name          = "one-color"
        target_branch = "main"
      },
    }
    "mid" = {
      "two-color" = {
        name          = "two-color"
        target_branch = "main"
      }
    }
    ext = {
      "status-01" = {
        name          = "status-01"
        target_branch = "main"
      }
    }
    # Puoi aggiungere altre app seguendo lo stesso pattern
  }
  flattened_applications = merge([
    for class, apps in local.argocd_applications : {
      for app_name, app in apps : app_name => merge(app, {
        class = class
      })
    }
  ]...)
}

resource "argocd_application" "diego_applications_blue" {
  for_each = local.flattened_applications

  metadata {
    name      = each.value.name
    namespace = var.domain
    labels = {
      name   = each.value.name
      domain = var.domain
      class  = each.value.class
      area   = var.domain
    }
  }

  spec {
    project = argocd_project.argocd_project_diego_blue.metadata[0].name

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
