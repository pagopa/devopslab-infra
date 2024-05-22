resource "kubernetes_namespace" "system_domain_namespace" {
  metadata {
    name = "${var.domain}-system"
  }
}

module "system_service_account" {
  source    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_service_account?ref=v8.13.0"
  name      = "azure-devops"
  namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_token" {
  name         = "${var.aks_name}-azure-devops-sa-token"
  value        = module.system_service_account.sa_token
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_cacrt" {
  name         = "${var.aks_name}-azure-devops-sa-cacrt"
  value        = module.system_service_account.sa_ca_cert
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

#-------------------------------------------------------------

resource "kubernetes_role_binding" "deployer_binding" {
  metadata {
    name      = "deployer-binding"
    namespace = kubernetes_namespace.domain_namespace.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  }
}

resource "kubernetes_role_binding" "system_deployer_binding" {
  metadata {
    name      = "system-deployer-binding"
    namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system-cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  }
}
