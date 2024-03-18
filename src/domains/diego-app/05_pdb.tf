#resource "kubernetes_pod_disruption_budget_v1" "diego" {
#  metadata {
#    name      = "${local.project}-pdb"
#    namespace = var.domain
#  }
#
#  spec {
#    min_available = 1
#
#    selector {
#      match_labels = {
#        "app.kubernetes.io/instance" : "devops-java-springboot-color"
#      }
#    }
#  }
#}
