resource "kubernetes_storage_class_v1" "standard_hdd" {
  metadata {
    name = "standard-hdd"
  }
  storage_provisioner = "kubernetes.io/azure-disk"
  reclaim_policy      = "Delete"
  parameters = {
    storageAccountType = "Standard_LRS"
  }
}
