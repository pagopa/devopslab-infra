data "azurerm_key_vault" "kv_core" {
  name                = "dvopla-d-neu-kv"
  resource_group_name = "dvopla-d-sec-rg"
}
