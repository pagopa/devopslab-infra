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
data "azurerm_key_vault_secret" "argocd_entra_client_id" {
  name         = "argocd-entra-client-id"
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
}

data "azurerm_key_vault_secret" "argocd_entra_client_secret" {
  name         = "argocd-entra-client-secret"
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
}

#
# Setup ArgoCD
#
resource "helm_release" "argocd" {
  name      = "argo"
  chart     = "https://github.com/argoproj/argo-helm/releases/download/argo-cd-${var.argocd_helm_release_version}/argo-cd-${var.argocd_helm_release_version}.tgz"
  namespace = kubernetes_namespace.namespace_argocd.metadata[0].name
  wait      = false

  values = [
    templatefile("${path.module}/argocd/argocd_helm_setup_values.yaml", {
      argocd_application_namespaces = var.argocd_application_namespaces
      tenant_id                     = data.azurerm_subscription.current.tenant_id
      client_id                     = data.azurerm_key_vault_secret.argocd_entra_client_id.value
    })
  ]

  depends_on = [
    module.aks,
  ]
}

resource "null_resource" "patch_argocd_entra_client_secret" {
  triggers = {
    secret_value    = base64encode(data.azurerm_key_vault_secret.argocd_entra_client_secret.value)
    force_reinstall = var.argocd_force_reinstall_version
  }

  provisioner "local-exec" {
    command = <<-EOT
      kubectl patch secret argocd-secret \
        -n argocd \
        -p='{"data": {"oidc.azure.clientSecret": "${base64encode(data.azurerm_key_vault_secret.argocd_entra_client_secret.value)}"}}' \
        --type=merge
    EOT
  }

  # Aggiungiamo anche un provisioner per la rimozione del secret quando la risorsa viene distrutta
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kubectl patch secret argocd-secret \
        -n argocd \
        -p='{"data": {"oidc.azure.clientSecret": null}}' \
        --type=merge
    EOT
  }

  depends_on = [
    data.azurerm_key_vault_secret.argocd_entra_client_secret,
    helm_release.argocd
  ]
}


#
# Admin Password
#
data "azurerm_key_vault_secret" "argocd_admin_password" {
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
  name         = "argocd-admin-password"
}

resource "null_resource" "argocd_change_admin_password" {

  triggers = {
    argocd_password = data.azurerm_key_vault_secret.argocd_admin_password.value
    force_reinstall = var.argocd_force_reinstall_version
  }

  provisioner "local-exec" {
    command = "kubectl -n argocd patch secret argocd-secret -p '{\"stringData\": {\"admin.password\":  \"${bcrypt(data.azurerm_key_vault_secret.argocd_admin_password.value)}\", \"admin.passwordMtime\": \"'$(date +%FT%T%Z)'\"}}'"
  }

  depends_on = [
    data.azurerm_key_vault_secret.argocd_admin_password,
    helm_release.argocd
  ]
}

resource "null_resource" "restart_argocd_server" {
  // Il blocco triggers assicura che il comando venga eseguito solo quando la variabile cambia
  triggers = {
    force_reinstall = var.argocd_force_reinstall_version
  }

  provisioner "local-exec" {
    // Esegui il comando kubectl per effettuare il restart del deployment
    command = "kubectl -n argocd rollout restart deployment/argo-argocd-server"
  }

  depends_on = [
    helm_release.argocd,
    null_resource.patch_argocd_entra_client_secret,
    null_resource.argocd_change_admin_password
  ]
}


resource "azurerm_key_vault_secret" "argocd_admin_username" {
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
  name         = "argocd-admin-username"
  value        = "admin"
}

#
# tools
#
module "argocd_workload_identity_init" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity_init?ref=v8.77.0"

  workload_identity_name_prefix         = "argocd"
  workload_identity_resource_group_name = azurerm_resource_group.rg_aks.name
  workload_identity_location            = var.location
}

module "argocd_workload_identity_configuration" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity_configuration?ref=v8.77.0"

  workload_identity_name_prefix         = "argocd"
  workload_identity_resource_group_name = azurerm_resource_group.rg_aks.name
  aks_name                              = module.aks.name
  aks_resource_group_name               = azurerm_resource_group.rg_aks.name
  namespace                             = kubernetes_namespace.namespace_argocd.metadata[0].name

  key_vault_id                      = data.azurerm_key_vault.kv_core_ita.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]

  depends_on = [module.argocd_workload_identity_init]
}

module "cert_mounter_argocd_internal" {
  source           = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v8.77.0"
  namespace        = "argocd"
  certificate_name = replace(local.argocd_internal_url, ".", "-")
  kv_name          = data.azurerm_key_vault.kv_core_ita.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_enabled              = true
  workload_identity_service_account_name = module.argocd_workload_identity_configuration.workload_identity_service_account_name
  workload_identity_client_id            = module.argocd_workload_identity_configuration.workload_identity_client_id

  depends_on = [
    module.argocd_workload_identity_configuration
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
