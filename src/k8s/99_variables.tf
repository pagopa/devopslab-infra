variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "usrreg"
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
}

#
# 🔐 Key Vault
#
variable "key_vault_name" {
  type        = string
  description = "Key Vault name"
  default     = ""
}

variable "key_vault_rg_name" {
  type        = string
  default     = ""
  description = "Key Vault - rg name"
}

#
# ⛴ AKS
#
variable "aks_private_cluster_enabled" {
  type        = bool
  description = "Enable or not public visibility of AKS"
  default     = false
}

#
# ⛴ K8s
#

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

# variable "k8s_apiserver_host" {
#   type = string
# }

variable "k8s_apiserver_port" {
  type    = number
  default = 443
}

variable "k8s_apiserver_insecure" {
  type    = bool
  default = false
}

variable "rbac_namespaces_for_deployer_binding" {
  type        = list(string)
  description = "Namespaces where to apply deployer binding rules"
}

# ingress

variable "ingress_replica_count" {
  type = string
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "default_service_port" {
  type    = number
  default = 8080
}

variable "nginx_helm_version" {
  type        = string
  description = "NGINX helm verison"
}

# # gateway
# variable "api_gateway_url" {
#   type = string
# }


# # configs/secrets

#
# 🀄️ LOCALS
#
locals {
  project                  = "${var.prefix}-${var.env_short}"
  public_ip_resource_group = "${var.prefix}-${var.env_short}-vnet-rg"
}
