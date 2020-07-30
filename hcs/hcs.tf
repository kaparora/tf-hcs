module "hcs" {
  source              = "cpu601/hcs/azurerm"
  version             = "0.4.0"
  resource_group_name = data.azurerm_resource_group.hcs.name
  application_name    = "${var.prefix}hcsapp"
  consul_cluster_name = "${var.prefix}cluster"
  external_endpoint   = true
  email               = var.email
  accept_marketplace_aggrement = true
  region              = var.location
  consul_cluster_mode = var.consul_cluster_mode
  managed_resource_group_name = "${var.prefix}-hcs-mrg"
  consul_datacenter_name = var.consul_datacenter_name
  vnet_starting_ip_address = var.hcs_vnet_starting_ip_address
}

output "consul_url" {
  value = module.hcs.consul_url
}