module "aks_storage_class" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_storage_class?ref=v7.69.1"
}

# resource "kubernetes_persistent_volume_claim_v1" "blueprint_file_share_premium_zrs" {
#   metadata {
#     name = "blueprint-file-share-premium-zrs"
#     namespace = "blueprint"
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

resource "kubernetes_persistent_volume_claim_v1" "blueprint_file_share_zrs" {
  metadata {
    name      = "blueprint-file-share-zrs"
    namespace = "blueprint"
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
