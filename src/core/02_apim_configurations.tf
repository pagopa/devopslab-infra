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

#   policy_xml = file("./api_product/uservice_user_registry_management/_base_policy.xml")
# }

# locals {
#   apim_uservice_user_registry_management_api = {
#     # params for all api versions
#     display_name          = "UserRegistry API"
#     description           = "UserRegistry APIs"
#     path                  = "user-registry-management"
#     subscription_required = true
#     service_url           = "http://${var.aks_private_cluster_enabled ? var.reverse_proxy_ip : data.azurerm_public_ip.aks_outbound[0].ip_address}/user-registry-management"
#   }
# }

# ##############
# ##    APIs  ##
# ##############

# ## USERREGISTRY
# resource "azurerm_api_management_api_version_set" "apim_uservice_user_registry_management_api" {
#   name                = format("%s-uservice-user-registry-management-api", var.env_short)
#   resource_group_name = module.apim.resource_group_name
#   api_management_name = module.apim.name
#   display_name        = local.apim_uservice_user_registry_management_api.display_name
#   versioning_scheme   = "Segment"
# }

# module "apim_uservice_user_registry_management_api_v1" {
#   source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.90"

#   name                  = format("%s-uservice-user-registry-management-api", var.env_short)
#   api_management_name   = module.apim.name
#   resource_group_name   = module.apim.resource_group_name
#   product_ids           = [module.apim_userregistry_product.product_id]
#   subscription_required = local.apim_uservice_user_registry_management_api.subscription_required
#   version_set_id        = azurerm_api_management_api_version_set.apim_uservice_user_registry_management_api.id
#   api_version           = "v1"
#   service_url           = "${local.apim_uservice_user_registry_management_api.service_url}/v1"

#   description  = local.apim_uservice_user_registry_management_api.description
#   display_name = local.apim_uservice_user_registry_management_api.display_name
#   path         = local.apim_uservice_user_registry_management_api.path
#   protocols    = ["https"]

#   content_format = "openapi"
#   content_value = templatefile("./api/uservice_user_registry_management/v1/_openapi.json.tpl", {
#     host     = local.api_internal_domain # api.internal.*.userregistry.pagopa.it
#     version  = "v1"
#     basePath = local.apim_uservice_user_registry_management_api.path
#   })

#   xml_content = file("./api/uservice_user_registry_management/v1/_base_policy.xml")
# }
