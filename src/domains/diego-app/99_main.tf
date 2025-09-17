terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.5"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.10.0"
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
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.31.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=50a29c79787596e3d3abfcf896ae2c6c683b25b6"
}

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
}

provider "helm" {
  kubernetes {
    config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
  }
}

provider "argocd" {
  server_addr = var.argocd_server_addr
  username    = data.azurerm_key_vault_secret.argocd_admin_username.value
  password    = data.azurerm_key_vault_secret.argocd_admin_password.value
  kubernetes {
    config_context = "config-${local.aks_name}"
  }
}
