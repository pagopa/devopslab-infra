resource "kubernetes_persistent_volume_claim_v1" "testit_hdd" {
  metadata {
    name      = "${var.domain}-hdd-pvc"
    namespace = var.domain
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "4Gi"
      }
    }
    storage_class_name = "standard-hdd"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "testit_ssd_az" {
  metadata {
    name      = "${var.domain}-ssd-az-pvc"
    namespace = var.domain
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "8Gi"
      }
    }
    storage_class_name = "managed-csi-premium-zrs"
  }
  wait_until_bound = false
}

# resource "kubernetes_persistent_volume_claim_v1" "testit_file_share_premium_zrs" {
#   metadata {
#     name = "testit-file-share-premium-zrs"
#     namespace = "testit"
#   }
#   spec {
#     access_modes = ["ReadWriteMany"]
#     resources {
#       requests = {
#         storage = "100Gi"
#       }
#     }
#     storage_class_name = "azurefile-premium-zrs"
#   }
# }

resource "kubernetes_persistent_volume_claim_v1" "testit_file_share_zrs" {
  metadata {
    name      = "testit-file-share-zrs"
    namespace = "testit"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "azurefile-zrs"
  }
}
