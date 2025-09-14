resource "kubernetes_namespace" "namespace_argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [
    module.aks
  ]
}

#
# OICD
#
data "azurerm_key_vault_secret" "argocd_entra_app_client_id" {
  name         = "argocd-entra-app-workload-client-id"
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
}

#
# Admin Password
#
data "azurerm_key_vault_secret" "argocd_admin_password" {
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
  name         = "argocd-admin-password"
}

#
# Setup ArgoCD (module)
#
module "argocd" {
  source = "./modules/argocd"

  namespace                         = kubernetes_namespace.namespace_argocd.metadata[0].name
  argocd_helm_release_version       = var.argocd_helm_release_version
  argocd_application_namespaces     = var.argocd_application_namespaces
  argocd_force_reinstall_version    = var.argocd_force_reinstall_version
  tenant_id                         = data.azurerm_subscription.current.tenant_id
  entra_app_client_id               = data.azurerm_key_vault_secret.argocd_entra_app_client_id.value
  argocd_internal_url               = local.argocd_internal_url
  kv_id                             = data.azurerm_key_vault.kv_core_ita.id
  aks_name                          = module.aks.name
  aks_resource_group_name           = azurerm_resource_group.rg_aks.name
  workload_identity_resource_group_name = azurerm_resource_group.rg_aks.name
  location                          = var.location
  internal_dns_zone_name            = data.azurerm_private_dns_zone.internal.name
  internal_dns_zone_resource_group_name = local.internal_dns_zone_resource_group_name
  ingress_load_balancer_ip          = var.ingress_load_balancer_ip
  dns_record_name_for_ingress       = local.ingress_hostname_prefix
  admin_password                    = data.azurerm_key_vault_secret.argocd_admin_password.value

  depends_on = [
    module.aks,
  ]
}

#---------------------------------------------------------------
# tools
#---------------------------------------------------------------

module "cert_mounter_argocd_internal" {
  source           = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v8.77.0"
  namespace        = "argocd"
  certificate_name = replace(local.argocd_internal_url, ".", "-")
  kv_name          = data.azurerm_key_vault.kv_core_ita.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_enabled              = true
  workload_identity_service_account_name = module.argocd.workload_identity_service_account_name
  workload_identity_client_id            = module.argocd.workload_identity_client_id

  depends_on = [
    module.argocd
  ]
}

resource "helm_release" "reloader_argocd" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.30"
  namespace  = kubernetes_namespace.namespace_argocd.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
