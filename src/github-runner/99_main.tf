terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.116.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.48.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=PAYMCLOUD-109-POC-Github-Runner-on-DevOpsLab"
}
