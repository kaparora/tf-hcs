resource "null_resource" "consul_config" {
    provisioner "local-exec" {
    command = "./hcs_config.sh"

    environment = {
      PREFIX = var.prefix
    }
  }
}