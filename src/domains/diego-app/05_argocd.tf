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
      name          = "one-color"
      target_branch = "main"
    },
    "two-color" = {
      name          = "two-color"
      target_branch = "main"
    }
    "three-color" = {
      name          = "three-color"
      target_branch = "main"
    }
    # Puoi aggiungere altre app seguendo lo stesso pattern
  }
}

# Creiamo l'ApplicationSet
resource "argocd_application_set" "diego_appset" {
  metadata {
    name      = "applicationset-${local.area}"
    namespace = "argocd"
  }

  spec {
    generator {
      list {
        elements = [
          for app_key, app in local.argocd_applications : {
            name         = app.name
            targetBranch = app.target_branch
          }
        ]
      }
    }

    template {
      metadata {
        name      = "${local.area}-{{name}}"
        namespace = "argocd"
        labels = {
          name   = "${local.area}-{{name}}"
          domain = var.domain
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
          target_revision = "{{targetBranch}}"
          path            = "helm/${var.env}/{{name}}"

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
    }
  }
}
