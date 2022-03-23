resource "null_resource" "enable_pod_identity" {
  # needs az extension
  # see https://docs.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity#before-you-begin

  triggers = {
    resource_group = format("%s-aks-rg", local.project)
    cluster_name   = data.azurerm_kubernetes_cluster.aks_cluster.name
  }

  provisioner "local-exec" {
    command = <<EOT
      az aks update \
        -g ${self.triggers.resource_group} \
        -n ${self.triggers.cluster_name} \
        --enable-pod-identity
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      az aks update \
        -g ${self.triggers.resource_group} \
        -n ${self.triggers.cluster_name} \
        --disable-pod-identity
    EOT
  }
}
