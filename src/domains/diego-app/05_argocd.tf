#
# Terraform argocd project
#
resource "argocd_project" "project" {
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

resource "argocd_application" "diego_applications" {
  for_each = local.flattened_applications

  metadata {
    name      = each.value.name
    namespace = "argocd"
    labels = {
      name   = each.value.name
      domain = var.domain
      class  = each.value.class
      area   = var.domain
    }
  }

  spec {
    project = argocd_project.project.metadata[0].name

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
