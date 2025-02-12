resource "azurerm_resource_group" "rg_docker" {
  name     = local.docker_rg_name
  location = var.location_ita
  tags     = var.tags
}

module "container_registry_public" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_registry"
  name                = local.docker_registry_name
  resource_group_name = azurerm_resource_group.rg_docker.name
  location            = azurerm_resource_group.rg_docker.location

  sku                           = "Basic"
  admin_enabled                 = false
  anonymous_pull_enabled        = false
  zone_redundancy_enabled       = false
  public_network_access_enabled = true
  private_endpoint_enabled      = false


  # georeplications = [{
  #   # location                  = var.location_seconsary
  #   regional_endpoint_enabled = false
  #   zone_redundancy_enabled   = false
  # }]

  tags = var.tags
}
