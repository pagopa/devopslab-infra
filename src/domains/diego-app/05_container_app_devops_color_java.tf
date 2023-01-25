data "template_file" "init_yaml_devops_color" {
  template = "${file("${path.module}/container-app/devops-java-springboot-color.yaml.tpl")}"
  vars = {
    REVISION_ID = local.container_app_devops_java_springboot_color_revision_id
    DVOPLA-D-APPINSIGHTS-CONNECTION-STRING = module.domain_key_vault_secrets_query.values["dvopla-d-appinsights-connection-string"].value
    CONTAINER_APP_DEVOPS_JAVA_SPRINGBOOT_COLOR_NAME = local.container_app_devops_java_springboot_color_name
    CONTAINER_APP_DIEGO_ENVIRONMENT_RESOURCE_GROUP = local.container_app_diego_environment_resource_group
    CONTAINER_APP_DIEGO_ENVIRONMENT_NAME = local.container_app_diego_environment_name
  }
}

resource "local_file" "save_yaml_file_devops_color" {
  content  = data.template_file.init_yaml_devops_color.rendered
  filename = "${local.container_app_devops_java_springboot_color_yaml_file_name}"
}

resource "null_resource" "apply_container_app_yaml_devops_color" {

  triggers = {
    REVISION_ID = local.container_app_devops_java_springboot_color_revision_id
  }

  provisioner "local-exec" {
    command = <<EOT
      az containerapp create --name ${local.container_app_devops_java_springboot_color_name} \
      --resource-group ${azurerm_resource_group.container_app_diego.name} \
      --environment ${local.container_app_diego_environment_name} \
      --yaml "${local.container_app_devops_java_springboot_color_yaml_file_name}"
    EOT
  }

  depends_on = [
    data.template_file.init_yaml_devops_color,
    local_file.save_yaml_file_devops_color,
    null_resource.container_app_create_env,
  ]
}
