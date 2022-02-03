##############
## Products ##
##############

module "apim_product_devopslab" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.90"

  product_id   = "devopslab"
  display_name = "DevOpsLab Product"
  description  = "Product for DevOpsLab backend"

  api_management_name = module.apim.name
  resource_group_name = module.apim.resource_group_name

  published             = true
  subscription_required = true
  approval_required     = false

  policy_xml = file("./api_product/devopslab/_base_policy.xml")
}


##############
##    APIs  ##
##############

locals {
  apim_devopslab_webapp_python_api = {
    # params for all api versions
    display_name          = "DevOpsLab API"
    description           = "DevOpsLab APIs"
    path                  = "devopslab-webapp-python"
    subscription_required = true
    # service_url           = "http://${var.aks_private_cluster_enabled ? var.reverse_proxy_ip : data.azurerm_public_ip.aks_outbound[0].ip_address}/user-registry-management"
    service_url           = "http://google.it"
    api_name              = "${var.env}-devopslab-webapp-python-api"
  }
}

## DEVOPSLAB
resource "azurerm_api_management_api_version_set" "apim_devopslab_webapp_python_api" {
  name                = local.apim_devopslab_webapp_python_api.api_name
  resource_group_name = module.apim.resource_group_name
  api_management_name = module.apim.name
  display_name        = local.apim_devopslab_webapp_python_api.display_name
  versioning_scheme   = "Segment"
}

module "apim_devopslab_webapp_python_api_v1" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.90"

  name                  = local.apim_devopslab_webapp_python_api.api_name
  api_management_name   = module.apim.name
  product_ids           = [module.apim_product_devopslab.product_id]
  subscription_required = local.apim_devopslab_webapp_python_api.subscription_required
  version_set_id        = azurerm_api_management_api_version_set.apim_devopslab_webapp_python_api.id
  api_version           = "v1"
  service_url           = "${local.apim_devopslab_webapp_python_api.service_url}/v1"
  resource_group_name   = module.apim.resource_group_name

  description  = local.apim_devopslab_webapp_python_api.description
  display_name = local.apim_devopslab_webapp_python_api.display_name
  path         = local.apim_devopslab_webapp_python_api.path
  protocols    = ["https"]

  content_format = "openapi"
  content_value = templatefile("./api/devopslab/v1/_openapi.json.tpl", {
    host     = local.api_internal_domain # api.internal.*.userregistry.pagopa.it
    version  = "v1"
    basePath = local.apim_devopslab_webapp_python_api.path
  })

  xml_content = file("./api/devopslab/v1/_base_policy.xml")
}
