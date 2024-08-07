resource "azurerm_user_assigned_identity" "this" {
  name = "${var.domain}-workload-identity"

  resource_group_name = local.aks_resource_group_name
  location            = var.location
}

resource "azurerm_key_vault_access_policy" "this" {

  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tenant_id    = data.azurerm_subscription.current.tenant_id

  # The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.
  object_id = azurerm_user_assigned_identity.this.principal_id

  certificate_permissions = ["Get"]
  key_permissions         = ["Get"]
  secret_permissions      = ["Get"]

  depends_on = [
    azurerm_user_assigned_identity.this
  ]
}

resource "kubernetes_service_account_v1" "workload_identity_sa" {
  metadata {
    name      = "${var.domain}-workload-identity"
    namespace = var.domain
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.this.client_id
    }
  }
}
