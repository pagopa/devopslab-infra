terraform {
  required_version = ">=1.8.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "<= 3.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 4.16.0"
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
