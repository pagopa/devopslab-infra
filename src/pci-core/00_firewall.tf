locals {
  fw_network_rules = { for idx, rule in var.firewall_network_rules : rule.name => {
    idx : idx,
    rule : rule,
    }
  }

  fw_application_rules = { for idx, rule in var.firewall_application_rules : rule.name => {
    idx : idx,
    rule : rule,
    }
  }

  fw_application_rules_tags = { for idx, rule in var.firewall_application_rules_tags : rule.name => {
    idx : idx,
    rule : rule,
    }
  }
}

resource "azurerm_public_ip" "fw_pip" {
  name                = format("%s-firewall-outbound-pip", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.pci_availability_zones
}

resource "azurerm_public_ip" "fw_mbg_pip" {
  name                = format("%s-firewall-mng-outbound-pip", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.pci_availability_zones
}

/* resource "azurerm_firewall" "pci_fw" {
  name                = format("%s-firewall", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.firewall_snet.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}
 */
resource "azurerm_firewall" "fw" {
  name                = format("%s-firewall", local.project)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  # firewall_policy_id  = var.firewall_policy != null ? azurerm_firewall_policy.fw-policy.0.id : null
  private_ip_ranges = var.cidr_firewall_subnet
  threat_intel_mode = "Alert"
  zones             = var.pci_availability_zones

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.firewall_snet.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }

  management_ip_configuration {
    name                 = "configuration-forced-tunnel"
    subnet_id            = module.firewall_mng_snet.id
    public_ip_address_id = azurerm_public_ip.fw_mbg_pip.id
  }

}

resource "azurerm_firewall_network_rule_collection" "fw" {
  for_each            = local.fw_network_rules
  name                = lower(format("%s-fw-net-rule-${local.project}", each.key))
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  priority            = 100 + (each.value.idx + 1)
  action              = each.value.rule.action

  dynamic "rule" {
    for_each = each.value.rule.rules

    content {
      name                  = rule.value.policyname
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      destination_fqdns     = rule.value.destination_fqdns
      protocols             = rule.value.protocols
    }
  }
}

#----------------------------------------------
# Azure Firewall Network/Application/NAT Rules 
#----------------------------------------------
resource "azurerm_firewall_application_rule_collection" "fw_app" {
  for_each            = local.fw_application_rules
  name                = lower(format("%s-fw-app-rule-${local.project}", each.key))
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  priority            = 100 + (each.value.idx + 1)
  action              = each.value.rule.action


  dynamic "rule" {
    for_each = each.value.rule.rules

    content {
      name             = rule.value.policyname
      source_addresses = rule.value.source_addresses
      source_ip_groups = rule.value.source_ip_groups
      fqdn_tags        = rule.value.fqdn_tags
      target_fqdns     = rule.value.target_fqdns
      protocol {
        type = rule.value.protocol.type
        port = rule.value.protocol.port
      }
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "fw_app_tags" {
  for_each            = local.fw_application_rules_tags
  name                = lower(format("%s-fw-app-rule-${local.project}", each.key))
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  priority            = 500 + (each.value.idx + 1)
  action              = each.value.rule.action


  dynamic "rule" {
    for_each = each.value.rule.rules

    content {
      name             = rule.value.policyname
      source_addresses = rule.value.source_addresses
      source_ip_groups = rule.value.source_ip_groups
      fqdn_tags        = rule.value.fqdn_tags
      target_fqdns     = rule.value.target_fqdns
    }
  }
}
