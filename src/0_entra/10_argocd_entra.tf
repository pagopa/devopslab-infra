# ⚠️
# ⚠️ The grant admin for pagopa.it consent step must be performed manually in the Azure Portal after applying this configuration.
# ⚠️ In App > API permissions > Microsoft Graph > User.Read > Grant admin consent for pagopa.it
# ⚠️

# -----------------------------------------------------------------------------
# Application Registration & Service Principal
# -----------------------------------------------------------------------------

resource "azuread_application" "argocd" {
  display_name = "${var.prefix}-${var.env}-argocd"
  owners       = data.azuread_users.argocd_application_owners.object_ids

  web {
    redirect_uris = ["https://${local.argocd_hostname}/auth/callback"]
    logout_url    = "https://${local.argocd_hostname}/logout"
  }

  # This configures the "Mobile and desktop applications" platform in Entra ID.
  public_client {
    redirect_uris = ["http://localhost:8085/auth/callback"]
  }

  group_membership_claims = [
    "ApplicationGroup"
  ]

  # MODIFICATION: Explicitly define ALL required delegated permissions for the OIDC flow.
  required_resource_access {
    resource_app_id = data.azuread_service_principal.graph.client_id

    # Permission: User.Read
    resource_access {
      # Allows the app to sign in users and read their basic profile.
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  optional_claims {
    id_token {
      name      = "groups"
      essential = true
      source    = null
    }
  }
}

resource "azuread_service_principal" "sp_argocd" {
  client_id = azuread_application.argocd.client_id
  owners    = data.azuread_users.argocd_application_owners.object_ids
}

# -----------------------------------------------------------------------------
# Permissions and Consent
# -----------------------------------------------------------------------------

# The claim_values list must now match all the permissions defined above.
resource "azuread_service_principal_delegated_permission_grant" "argocd_user_read_consent" {
  # The Object ID of the Service Principal receiving the grant.
  service_principal_object_id = azuread_service_principal.sp_argocd.object_id

  # The Object ID of the API being granted access to (Microsoft Graph).
  resource_service_principal_object_id = data.azuread_service_principal.graph.object_id

  # The list of permissions (scopes) to grant. Must match what was requested.
  claim_values = ["User.Read"]

  # The Object ID of the user/principal granting the consent.
  user_object_id = data.azurerm_client_config.current.object_id
}

# Assigns the specified Entra ID groups to the ArgoCD Enterprise Application.
# This is required because 'group_membership_claims' is set to 'ApplicationGroup'.
resource "azuread_app_role_assignment" "argocd_group_assignments" {
  for_each = data.azuread_group.argocd_groups

  app_role_id         = "00000000-0000-0000-0000-000000000000"
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.sp_argocd.object_id
}

# -----------------------------------------------------------------------------
# Workload Identity Federation
# -----------------------------------------------------------------------------

resource "azuread_application_federated_identity_credential" "argocd" {
  application_id = azuread_application.argocd.id
  display_name   = "${local.project}-argocd-server-federated-credential"
  description    = "Federated credential for the ArgoCD server service account"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject        = "system:serviceaccount:${local.argocd_namespace}:${local.argocd_service_account_name}"
}

# -----------------------------------------------------------------------------
# Key Vault Secrets
# -----------------------------------------------------------------------------

resource "azurerm_key_vault_secret" "argocd_entra_app_client_id" {
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
  name         = "argocd-entra-app-workload-client-id"
  value        = azuread_application.argocd.client_id
}

resource "azurerm_key_vault_secret" "argocd_entra_app_service_account_name" {
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
  name         = "argocd-entra-app-workload-service-account-name"
  value        = local.argocd_service_account_name
}
