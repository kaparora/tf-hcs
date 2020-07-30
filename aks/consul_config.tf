resource "null_resource" "consul_config" {
    depends_on = [azurerm_kubernetes_cluster.aks]
    provisioner "local-exec" {
    command = "./hcs_config.sh"

    environment = {
      PREFIX = var.prefix
    }
  }
}