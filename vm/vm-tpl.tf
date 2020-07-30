data "template_file" "vm_setup" {
  template = "${file("${path.module}/setup-vm.tpl")}"

  vars = {
    consul_download_url  = "${var.consul_download_url}"
    consul_json = data.local_file.cj.content
    ca_file     = data.local_file.ca.content
  }
}


data "local_file" "cj" {
  depends_on = [null_resource.consul_config]
  filename    = "consul.json"
}
data "local_file" "ca" {
  depends_on = [null_resource.consul_config]
  filename   = "../hcs/ca.pem"
}