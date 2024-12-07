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
    "one-color" = {
      name           = "one-color"
      target_branch  = "main"
    },
    "two-color" = {
      name           = "two-color"
      target_branch  = "main"
    }
    # Puoi aggiungere altre app seguendo lo stesso pattern
  }
}

# Creiamo le singole Applications
resource "argocd_application" "diego_apps" {
  for_each = local.argocd_applications

  metadata {
    name      = "${local.area}-${each.value.name}"
    namespace = "argocd"
    labels = {
      name   = "${local.area}-${each.value.name}"
      domain = var.domain
      area = local.area
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
      path           = "helm/${var.env}/${each.value.name}"

      helm {
        values = yamlencode({
          microservice-chart: {
            azure: {
              workloadIdentityClientId: module.workload_identity.workload_identity_client_id
            }
          }
        })
        ignore_missing_value_files = false
        pass_credentials           = false
        skip_crds                  = false
        value_files                = []
      }
    }

    # Decommentare e modificare se necessario
    # sync_policy {
    #   automated {
    #     prune       = true
    #     self_heal   = false
    #     allow_empty = false
    #   }
    #   retry {
    #     backoff {
    #       duration     = "5s"
    #       factor       = "2"
    #       max_duration = "3m0s"
    #     }
    #     limit = "5"
    #   }
    # }
  }

  depends_on = [
    argocd_project.project
  ]
}
