resource "azurerm_resource_group" "main" {
  name     = "${local.project}-matteo-rg"
  location = var.location

  tags = var.tags
}
