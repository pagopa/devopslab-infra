module "aks_storage_class" {
  source = "./.terraform/modules/__v4__/kubernetes_storage_class"

  depends_on = [module.aks]
}
