terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.116.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "<= 2.50.0"
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

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.61.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=a88c6d99ec3871db7de57db4280422b02db3e4f0"
}
