module "aks_storage_class" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_storage_class?ref=v8.21.0"

  depends_on = [module.aks]
}
