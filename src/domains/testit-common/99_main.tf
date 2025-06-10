terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.18"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v5.11.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=breaking-change-idh-names"
}
