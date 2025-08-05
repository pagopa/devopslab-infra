# This file defines the Entra ID Application, Service Principal,
# and necessary permissions for ArgoCD SSO integration.

# -----------------------------------------------------------------------------
# Data Sources
# -----------------------------------------------------------------------------

data "azuread_service_principal" "graph" {
  display_name = "Microsoft Graph"
}

# data "azurerm_client_config" "current" {}

data "azuread_group" "argocd_groups" {
  for_each     = toset(var.argocd_entra_groups_allowed)
  display_name = each.value
}

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
    # Permission: email
    resource_access {
      # Allows the app to read the user's primary email address.
      id   = "64a6cdd6-aab1-426b-a145-b83c2999e0fe" # email
      type = "Scope"
    }
    # Permission: openid
    resource_access {
      # Required for OIDC authentication flow to sign in users.
      id   = "37f7f235-527c-4136-ac94-e5e6a2a07599" # openid
      type = "Scope"
    }
    # Permission: offline_access
    resource_access {
      # Allows the app to maintain access to data on behalf of the user for an extended period.
      # This resolves the "Maintain access" prompt.
      id   = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182" # offline_access
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

resource "azuread_service_principal" "argocd" {
  client_id = azuread_application.argocd.client_id
  owners    = data.azuread_users.argocd_application_owners.object_ids
}

# -----------------------------------------------------------------------------
# Permissions and Consent
# -----------------------------------------------------------------------------

# MODIFICATION: Grant admin consent for ALL requested permissions.
# The claim_values list must now match all the permissions defined above.
resource "azuread_service_principal_delegated_permission_grant" "argocd_graph_consent" {
  service_principal_object_id          = azuread_service_principal.argocd.object_id
  resource_service_principal_object_id = data.azuread_service_principal.graph.object_id
  claim_values = [
    "User.Read",
    "email",
    "openid",
    "offline_access"
  ]
  user_object_id = data.azurerm_client_config.current.object_id
}

# Assigns the specified Entra ID groups to the ArgoCD Enterprise Application.
# This is required because 'group_membership_claims' is set to 'ApplicationGroup'.
resource "azuread_app_role_assignment" "argocd_group_assignments" {
  for_each = data.azuread_group.argocd_groups

  app_role_id         = "00000000-0000-0000-0000-000000000000"
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.argocd.object_id
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
