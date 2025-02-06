data "azurerm_key_vault" "kv_core_ita" {
  name                = "dvopla-d-itn-core-kv"
  resource_group_name = "dvopla-d-itn-sec-rg"
}
