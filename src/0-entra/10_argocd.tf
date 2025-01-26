# Application registration
resource "azuread_application" "argocd" {
  display_name = "${var.prefix}-${var.env}-argocd"
  owners = data.azuread_users.argocd_application_owners.object_ids

  # Nuova sintassi per web app
  single_page_application {
    redirect_uris = ["https://argocd.internal.devopslab.pagopa.it/auth/callback"]
  }

  # API permissions per Microsoft Graph
  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access ArgoCD on behalf of the signed-in user."
      admin_consent_display_name = "Access ArgoCD"
      enabled                   = true
      id                        = uuid()
      type                      = "User"
      user_consent_description  = "Allow the application to access ArgoCD on your behalf."
      user_consent_display_name = "Access ArgoCD"
      value                     = "user_impersonation"
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
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
        id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
         type = "Scope"
      }
  }
}

# Secret generation
resource "azuread_application_password" "argocd" {
  display_name = "ArgoCD Secret"
  application_id = azuread_application.argocd.id

  # Utilizziamo end_date invece di end_date_relative
  end_date = timeadd(timestamp(), "8760h")

  rotate_when_changed = {
    rotation = timestamp()
  }
}

# Service Principal
resource "azuread_service_principal" "argocd" {
  client_id = azuread_application.argocd.client_id
  use_existing   = true

  feature_tags {
    enterprise = true
    gallery    = true
  }


}
