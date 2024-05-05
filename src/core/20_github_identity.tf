data "azurerm_resource_group" "identity_rg" {
  name = "dvopla-d-identity-rg"
}

# repos must be lower than 20 items
locals {
  repos_01 = [
    "github-self-hosted-runner-azure",
  ]

  federations_01 = [
    for repo in local.repos_01 : {
      repository = repo
      subject    = var.env
    }
  ]

  # to avoid subscription Contributor -> https://github.com/microsoft/azure-container-apps/issues/35
  environment_cd_roles = {
    subscription = [
      "Contributor"
    ]
    resource_groups = {
      #       "${local.product}-${var.domain}-sec-rg" = [
      #         "Key Vault Reader"
      #       ],
      #       "${local.product}-${var.location_short}-${var.env}-aks-rg" = [
      #         "Contributor"
      #       ]
    }
  }
}

# create a module for each 20 repos
module "identity_cd_01" {
  source = "github.com/pagopa/terraform-azurerm-v3//github_federated_identity?ref=v8.5.0"
  # pagopa-<ENV><DOMAIN>-<COUNTER>-github-<PERMS>-identity
  prefix    = var.prefix
  env_short = var.env_short
  domain    = "${var.domain}-01"

  identity_role = "cd"

  github_federations = local.federations_01

  cd_rbac_roles = {
    subscription_roles = local.environment_cd_roles.subscription
    resource_groups    = local.environment_cd_roles.resource_groups
  }

  tags = var.tags

  depends_on = [
    data.azurerm_resource_group.identity_rg
  ]
}
