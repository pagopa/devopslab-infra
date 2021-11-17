
# #########
# ## API ##
# #########

# ## monitor ##
# module "monitor" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.58"
#   name                = format("%s-monitor", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name

#   description  = "Monitor"
#   display_name = "Monitor"
#   path         = ""
#   protocols    = ["https"]

#   service_url = null

#   content_format = "openapi"
#   content_value = templatefile("./api/monitor/openapi.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   subscription_required = false

#   api_operation_policies = [
#     {
#       operation_id = "get"
#       xml_content  = file("./api/monitor/mock_policy.xml")
#     }
#   ]
# }

# resource "azurerm_api_management_api_version_set" "apim_hub_spid_login_api" {
#   name                = format("%s-spid-login-api", var.env_short)
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "SPID"
#   versioning_scheme   = "Segment"
# }

# module "apim_hub_spid_login_api_v1" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.58"
#   name                = format("%s-spid-login-api-v1", local.project)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.apim_hub_spid_login_api.id

#   description  = "Login SPID Service Provider"
#   display_name = "SPID V1"
#   path         = "spid/v1"
#   protocols    = ["https"]

#   service_url = format("http://%s/hub-spid-login-ms", var.reverse_proxy_ip)

#   content_format = "swagger-json"
#   content_value = templatefile("./api/hubspidlogin_api/swagger.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/hubspidlogin_api/policy.xml")

#   subscription_required = false


#   api_operation_policies = [
#     {
#       operation_id = "postACS"
#       xml_content  = templatefile("./api/hubspidlogin_api/postacs_policy.xml.tpl", {
#         origins = local.origins.spidAcsOrigins
#       })
#     },
#     {
#       operation_id = "getMetadata"
#       xml_content  = file("./api/hubspidlogin_api/metadata_policy.xml.tpl")
#     }
#   ]
# }

# resource "azurerm_api_management_api_version_set" "pdnd_interop_party_prc" {
#   name                = format("%s-party-prc-api", var.env_short)
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "Party Process Micro Service"
#   versioning_scheme   = "Segment"
# }

# module "pdnd_interop_party_prc_v1" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.58"
#   name                = format("%s-party-prc-api-v1", local.project)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.pdnd_interop_party_prc.id

#   description  = "This service is the party process"
#   display_name = "Party Process Micro Service V1"
#   path         = "party-process/v1"
#   protocols    = ["https"]

#   service_url = format("http://%s/pdnd-interop-uservice-party-process-client", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/party_process/party-process.yml.tpl", {
#     host     = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#     basePath = "party-process/v1"
#   })

#   xml_content = file("./api/base_policy.xml")

#   subscription_required = false

#   // TODO these are mocks! remove me after integration
#   api_operation_policies = [
#     {
#       operation_id = "getOnBoardingInfo"
#       xml_content  = file("./api/party_process/getOnBoardingInfo_policy.xml")
#     },
#     {
#       operation_id = "createLegals"
#       xml_content  = file("./api/party_process/createLegals_policy.xml")
#     }
#   ]
# }

# resource "azurerm_api_management_api_version_set" "apim_pdnd_interop_party_mgmt" {
#   name                = format("%s-party-mgmt-api", var.env_short)
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "Party Management Micro Service"
#   versioning_scheme   = "Segment"
# }

# module "apim_pdnd_interop_party_mgmt-v1" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.58"
#   name                = format("%s-party-mgmt-api-v1", local.project)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.apim_pdnd_interop_party_mgmt.id

#   description  = "This service is the party manager"
#   display_name = "Party Management Micro Service V1"
#   path         = "party-management/v1"
#   protocols    = ["https"]

#   service_url = format("http://%s/pdnd-interop-uservice-party-management-client", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/party_management/party-management.yml.tpl", {
#     host     = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#     basePath = "party-management/v1"
#   })

#   xml_content = file("./api/base_policy.xml")

#   subscription_required = false

#   // TODO these are mocks! remove me after integration
#   api_operation_policies = [
#     {
#       operation_id = "getOrganizationById"
#       xml_content  = file("./api/party_management/getOrganizationById_policy.xml")
#     }
#   ]
# }

# resource "azurerm_api_management_api_version_set" "pdnd_interop_party_reg_proxy" {
#   name                = format("%s-party-reg-proxy-api", var.env_short)
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "Party Registry Proxy Server"
#   versioning_scheme   = "Segment"
# }

# module "pdnd_interop_party_reg_proxy-v1" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.58"
#   name                = format("%s-party-reg-proxy-api-v1", local.project)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.pdnd_interop_party_reg_proxy.id

#   description  = "This service is the proxy to the party registry"
#   display_name = "Party Registry Proxy Server V1"
#   path         = "party-registry-proxy/v1"
#   protocols    = ["https"]

#   service_url = format("http://%s/pdnd-interop-uservice-party-registry-proxy", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/party_registry_proxy/party-registry-proxy.yml.tpl", {
#     host     = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#     basePath = "party-registry-proxy/v1"
#   })

#   xml_content = file("./api/base_policy.xml")

#   subscription_required = false

#   // TODO these are mocks! remove me after integration
#   api_operation_policies = [
#     {
#       operation_id = "searchInstitution"
#       xml_content  = file("./api/party_registry_proxy/searchInstitution_policy.xml")
#     }
#   ]
# }
