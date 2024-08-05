terraform {
  required_version = ">=1.8.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.114.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "<= 2.50.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "<= 2.4.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "<= 2.0.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "<= 2.31.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "<= 2.14.0"
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

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_cluster_name}"
}

provider "helm" {
  kubernetes {
    config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_cluster_name}"
  }
}
