resource "null_resource" "consul_config" {
    depends_on = [module.hcs]
    provisioner "local-exec" {
    command = "./hcs_config.sh"

    environment = {
      PREFIX = var.prefix
    }
  }
}