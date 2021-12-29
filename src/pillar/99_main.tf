terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.90.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.10.0"
    }
    null = {
      version = "= 3.1.0"
    }

  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
