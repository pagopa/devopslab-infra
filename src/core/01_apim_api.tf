# ##############
# ## Products ##
# ##############

# module "apim_userregistry_product" {
#   source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.90"

#   product_id   = "userregistry"
#   display_name = "UserRegistry"
#   description  = "Product for UserRegistry backend"

#   api_management_name = module.apim.name
#   resource_group_name = module.apim.resource_group_name

#   published             = true
#   subscription_required = true
#   approval_required     = false

#   policy_xml = file("./api_product/userregistry/_base_policy.xml")
# }

# locals {
#   apim_userregistry_api = {
#     # params for all api versions
#     display_name          = "UserRegistry API"
#     description           = "UserRegistry APIs"
#     path                  = "api/userregistry"
#     subscription_required = true
#     # service_url           = format("https://%s", module.app_container.default_site_hostname)
#     service_url = "https://google.it"
#   }
# }

# ##############
# ##    APIs  ##
# ##############

# ## USERREGISTRY
# resource "azurerm_api_management_api_version_set" "userregistry_api" {
#   name                = format("%s-userregistry-api", var.env_short)
#   resource_group_name = module.apim.resource_group_name
#   api_management_name = module.apim.name
#   display_name        = local.apim_userregistry_api.display_name
#   versioning_scheme   = "Segment"
# }

# module "apim_userregistry_api_v1" {
#   source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.90"

#   name                  = format("%s-userregistry-api", var.env_short)
#   api_management_name   = module.apim.name
#   resource_group_name   = module.apim.resource_group_name
#   product_ids           = [module.apim_userregistry_product.product_id]
#   subscription_required = local.apim_userregistry_api.subscription_required
#   version_set_id        = azurerm_api_management_api_version_set.userregistry_api.id
#   api_version           = "v1"
#   service_url           = local.apim_userregistry_api.service_url

#   description  = local.apim_userregistry_api.description
#   display_name = local.apim_userregistry_api.display_name
#   path         = "pdnd-interop-uservice-user-registry-management"
#   protocols    = ["https"]

#   content_format = "openapi"
#   content_value = templatefile("./api/userregistry/v1/_openapi.json.tpl", {
#     host    = local.api_internal_domain # api.internal.*.userregistry.pagopa.it
#     version = "v1"
#   })

#   xml_content = file("./api/userregistry/v1/_base_policy.xml")
# }
# ##
