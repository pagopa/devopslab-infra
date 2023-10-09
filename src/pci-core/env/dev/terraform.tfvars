#
# General
#
env_short      = "d"
env            = "dev"
prefix         = "dvopla"
location       = "northeurope"
location_short = "neu"
domain         = "pci-core"

#DR var
enable_region_dr  = false
location_dr       = "northeurope"
location_short_dr = "neu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "PCI"
  Source      = "https://github.com/pagopa/pci-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# DNS
#
dns_zone_product_prefix = "devopslab"

cidr_firewall_subnet     = ["10.1.240.0/24"]
cidr_firewall_mng_subnet = ["10.1.241.0/24"]

enable_iac_pipeline = true

external_domain          = "pagopa.it"
dns_zone_prefix          = "devopslab"
dns_zone_internal_prefix = "internal.devopslab"

firewall_network_rules = [
  {
    name   = "application-rule"
    action = "Allow"
    rules = [
      {
        policyname            = "aks-to-evh"
        source_addresses      = ["10.2.0.0/17"]
        destination_ports     = ["9093"]
        destination_addresses = ["10.3.3.0/27"]
        protocols             = ["TCP"]
      },
    ]
  },
  {
    name   = "frontend-rule"
    action = "Allow"
    rules = [
      {
        policyname            = "ft-to-aks"
        source_addresses      = ["10.1.0.0/16"]
        destination_ports     = ["443"]
        destination_addresses = ["10.2.0.0/17"]
        protocols             = ["TCP"]
      },
    ]
  },
]

firewall_application_rules = [
  {
    name   = "internet"
    action = "Allow"
    rules = [
      {
        policyname       = "microsoft-default-https"
        source_addresses = ["10.0.0.0/8"]
        target_fqdns     = ["*.microsoft.com", "aksrepos.azurecr.io", "*blob.core.windows.net", "mcr.microsoft.com", "*cdn.mscr.io", "*.data.mcr.microsoft.com", "management.azure.com", "login.microsoftonline.com", "ntp.ubuntu.com", "packages.microsoft.com", "acs-mirror.azureedge.net", "*.windows.net", "*.microsoftmetrics.com"]
        protocol = {
          type = "Https"
          port = "443"
        }
      },
      {
        policyname       = "microsoft-default-http"
        source_addresses = ["10.0.0.0/8"]
        target_fqdns     = ["*.microsoft.com", "aksrepos.azurecr.io", "*blob.core.windows.net", "mcr.microsoft.com", "*cdn.mscr.io", "*.data.mcr.microsoft.com", "management.azure.com", "login.microsoftonline.com", "ntp.ubuntu.com", "packages.microsoft.com", "acs-mirror.azureedge.net", "*.windows.net", "*.microsoftmetrics.com"]
        protocol = {
          type = "Http"
          port = "80"
        }
      },
      {
        policyname       = "keda"
        source_addresses = ["10.2.0.0/16"]
        target_fqdns     = ["ghcr.io"]
        protocol = {
          type = "Https"
          port = "443"
        }
      },
      {
        policyname       = "nginx"
        source_addresses = ["10.2.0.0/16"]
        target_fqdns     = ["k8s.gcr.io"]
        protocol = {
          type = "Https"
          port = "443"
        }
      },
    ]
  },
]

firewall_application_rules_tags = [
  {
    name   = "aks-internal"
    action = "Allow"
    rules = [
      {
        policyname = "aks-fqdn"

        source_addresses = [
          "10.1.0.0/16",
          "10.2.0.0/16",
        ]

        fqdn_tags = [
          "AzureKubernetesService",
        ]
      },
    ]
  },
]
