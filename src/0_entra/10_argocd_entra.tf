#
# Application registration
#
resource "azuread_application" "argocd" {
  display_name = "${var.prefix}-${var.env}-argocd"
  owners       = data.azuread_users.argocd_application_owners.object_ids

  # Nuova sintassi per web app
  web {
    redirect_uris = ["https://${local.argocd_hostname}/auth/callback"]
    logout_url    = "https://${local.argocd_hostname}/logout"
  }

  group_membership_claims = [
    "ApplicationGroup"
  ]

  # API permissions per Microsoft Graph
  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access ArgoCD on behalf of the signed-in user."
      admin_consent_display_name = "Access ArgoCD"
      enabled                    = true
      id                         = uuid()
      type                       = "User"
      user_consent_description   = "Allow the application to access ArgoCD on your behalf."
      user_consent_display_name  = "Access ArgoCD"
      value                      = "user_impersonation"
    }

    known_client_applications = []
  }

  # Configurazione corretta per claims
  optional_claims {
    id_token {
      # additional_properties = ["include_claim_in_token"]
      essential = true
      name      = "groups"
      source    = null
    }
  }

  feature_tags {
    enterprise = true
    gallery    = true
  }

  public_client {
    redirect_uris = [
      "http://localhost:8085/auth/callback",
    ]
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"  # User.Read

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }
}

#
# Federazione
#
resource "azuread_application_federated_identity_credential" "argocd" {
  application_id        = azuread_application.argocd.id
  display_name          = "${local.project}-argocd-server-federated-credential"
  description           = "Credenziale federata per il service account del server di ArgoCD"
  audiences             = ["api://AzureADTokenExchange"]

  # L'issuer del cluster Kubernetes. DEVI sostituirlo con il valore corretto del tuo cluster.
  # Esempio per AKS: "https://<region>.oic.prod-aks.azure.com/<tenant-id>/"
  issuer = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url

  # Il soggetto della credenziale, che identifica il Service Account
  # Formato: system:serviceaccount:<namespace>:<service-account-name>
  subject = "system:serviceaccount:${local.argocd_namespace}:${local.argocd_service_account_name}"
}

#
# Service Principal/Enterprise Application
#
resource "azuread_service_principal" "argocd" {
  client_id    = azuread_application.argocd.client_id
  use_existing = true

  owners = data.azuread_users.argocd_application_owners.object_ids

  feature_tags {
    enterprise = true
    gallery    = true
  }
}

# Recupera dinamicamente i gruppi esistenti su Entra ID
data "azuread_group" "argocd_groups" {
  for_each     = toset(var.argocd_entra_groups_allowed)
  display_name = each.value
}

resource "azuread_app_role_assignment" "argocd_group_assignments" {
  for_each = data.azuread_group.argocd_groups

  app_role_id         = "00000000-0000-0000-0000-000000000000"
  principal_object_id = each.value.object_id
  resource_object_id  = azuread_service_principal.argocd.object_id
}

#
# KV
#
resource "azurerm_key_vault_secret" "argocd_entra_app_client_id" {
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
  name         = "argocd-entra-app-client-id"
  value        = azuread_application.argocd.client_id
}

resource "azurerm_key_vault_secret" "argocd_entra_app_service_account_name" {
  key_vault_id = data.azurerm_key_vault.kv_core_ita.id
  name         = "argocd-entra-app-service-account-name"
  value        = local.argocd_service_account_name
}
