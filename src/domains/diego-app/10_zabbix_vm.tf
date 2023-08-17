data "azurerm_resource_group" "zabbix" {
  name = "${local.project}-zabbix"
}

resource "azurerm_subnet" "zabbix" {
  name                 = "zabbix-internal"
  resource_group_name  = data.azurerm_resource_group.rg_vnet_core.name
  virtual_network_name = data.azurerm_virtual_network.vnet_core.name
  address_prefixes     = var.cidr_subnet_zabbix_server
}

resource "azurerm_network_interface" "zabbix_nic" {
  name                = "zabbix-nic"
  location            = data.azurerm_resource_group.zabbix.location
  resource_group_name = data.azurerm_resource_group.zabbix.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.zabbix.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "tls_private_key" "zabbix_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "zabbix_private_key" {
  name         = "zabbix-private-key"
  value        = tls_private_key.zabbix_key.private_key_openssh
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

resource "azurerm_key_vault_secret" "zabbix_public_key" {
  name         = "zabbix-public-key"
  value        = tls_private_key.zabbix_key.public_key_openssh
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

#store ssh public key
resource "azurerm_ssh_public_key" "zabbix_public_key" {
  name                = "zabbix-admin-access-key"
  resource_group_name = data.azurerm_resource_group.zabbix.name
  location            = data.azurerm_resource_group.zabbix.location
  public_key          = tls_private_key.zabbix_key.public_key_openssh
}

resource "azurerm_linux_virtual_machine" "zabbix_vm" {
  name                = "${local.project}-zabbix"
  resource_group_name = data.azurerm_resource_group.zabbix.name
  location            = data.azurerm_resource_group.zabbix.location
  size                = "Standard_B2s"
  admin_username      = "zabbix"
  network_interface_ids = [
    azurerm_network_interface.zabbix_nic.id,
  ]

  admin_ssh_key {
    username   = "zabbix"
    public_key = tls_private_key.zabbix_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = "/subscriptions/ac17914c-79bf-48fa-831e-1359ef74c1d5/resourceGroups/dvopla-d-azdoa-rg/providers/Microsoft.Compute/images/azdo-agent-ubuntu2204-image-v2"
}
