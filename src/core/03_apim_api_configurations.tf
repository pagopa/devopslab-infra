# ##############
# ## Products ##
# ##############
#
# module "apim_product_blueprint" {
#   count = var.apim_enabled == true ? 1 : 0
#
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v8.5.0"
#
#   product_id   = "blueprint"
#   display_name = "blueprint product"
#   description  = "Product for blueprint backend"
#
#   api_management_name = module.apim[0].name
#   resource_group_name = module.apim[0].resource_group_name
#
#   published             = true
#   subscription_required = true
#   approval_required     = false
#
#   policy_xml = file("./api_product/blueprint/_base_policy.xml")
# }
#
#
# ##############
# ##   APIs   ##
# ##############
#
# # resource "azurerm_api_management_api_version_set" "apim_blueprint_product" {
# #   name                = local.apim_blueprint_product.api_name
# #   resource_group_name = module.apim.resource_group_name
# #   api_management_name = module.apim.name
# #   display_name        = local.apim_blueprint_product.display_name
# #   versioning_scheme   = "Segment"
# # }
#
# module "apim_blueprint_status_v1" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.5.0"
#   count  = var.apim_enabled == true ? 1 : 0
#
#
#   name                  = "${var.domain}-blueprint-status-api"
#   api_management_name   = module.apim[0].name
#   product_ids           = [module.apim_product_blueprint[0].product_id]
#   subscription_required = false
#   # version_set_id        = azurerm_api_management_api_version_set.apim_blueprint_product.id
#   # api_version           = "v1"
#   service_url         = "https://dev01.blueprint.internal.devopslab.pagopa.it/blueprint/v5-java-helm-basic-test/status"
#   resource_group_name = module.apim[0].resource_group_name
#
#   description  = "blueprint - status"
#   display_name = "blueprint - status"
#   path         = "blueprint"
#   protocols    = ["https"]
#
#   content_format = "openapi"
#   content_value = templatefile("./api/blueprint/status/openapi_webapp_python.json.tftpl", {
#     projectName = "${var.env}-status-api"
#   })
#
#   xml_content = file("./api/blueprint/status/_base_policy.xml")
# }
