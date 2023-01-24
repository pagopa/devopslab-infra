# Subnet to host the api config
module "container_apps_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v4.1.0"
  name                 = "${local.project}-container-apps-snet"
  address_prefixes     = var.cidr_subnet_container_apps
  virtual_network_name = data.azurerm_virtual_network.vnet_core.name

  resource_group_name = data.azurerm_resource_group.rg_vnet_core.name

  private_endpoint_network_policies_enabled = true
}

data "template_file" "init_yaml" {
  template = "${file("${path.module}/container-app/app.yaml.tpl")}"
  vars = {
    REVISION_ID = local.container_app_revision_id
  }
}

resource "local_file" save_yaml_file {
  content  = data.template_file.init_yaml.rendered
  filename = "/tmp/${local.container_app_revision_id}-app.yaml"
}

resource "null_resource" "apply_container_app_yaml" {

  triggers = {
    REVISION_ID = local.container_app_revision_id
  }

  provisioner "local-exec" {
    command = <<EOT
      az containerapp create -n "dvopla-d-diego-ambassador-capp" \
      -g "dvopla-d-diego-container-app-rg" \
      --environment "dvopla-d-diego-ambassador-cappenv" \
      --verbose \
      --debug \
      --yaml /tmp/${local.container_app_revision_id}-app.yaml
    EOT
  }

  depends_on = [
    data.template_file.init_yaml,
    local_file.save_yaml_file
  ]
}
