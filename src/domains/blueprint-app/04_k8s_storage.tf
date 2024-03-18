resource "kubernetes_persistent_volume_claim_v1" "blueprint_hdd" {
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

resource "kubernetes_persistent_volume_claim_v1" "blueprint_ssd_az" {
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
