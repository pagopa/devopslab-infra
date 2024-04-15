terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.96.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "<= 2.47.0"
    }
    null = {
      version = "<= 3.2.1"
    }
    azapi = {
      source  = "azure/azapi"
      version = "<= 1.12.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "<= 2.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "<= 3.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "<= 4.0.5"
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
