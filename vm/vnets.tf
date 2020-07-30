resource "azurerm_virtual_network" "vm" {
  name                = "${var.prefix}-vm-vnet"
  address_space       = ["${var.vm_vnet_cidr}"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.hcs.name
  tags = {
    owner = "${var.email}"
  }
}
resource "azurerm_subnet" "vm" {
  name                 = "${var.prefix}-vm-subnet"
  resource_group_name  = data.azurerm_resource_group.hcs.name
  virtual_network_name = azurerm_virtual_network.vm.name
  address_prefixes     = ["${var.vm_vnet_cidr}"]
}


resource "azurerm_virtual_network_peering" "tovm" {
  name                      = "hcstovm"
  resource_group_name       = data.azurerm_resource_group.hcs.name
  virtual_network_name      = azurerm_virtual_network.vm.name
  remote_virtual_network_id = data.azurerm_virtual_network.hcs.id
}

resource "azurerm_virtual_network_peering" "fromvm" {
  name                      = "vmtohcs"
  resource_group_name       = data.azurerm_virtual_network.hcs.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hcs.name
  remote_virtual_network_id = azurerm_virtual_network.vm.id
}



data "azurerm_virtual_network" "hcs" {
  name                = "hvn-consul-ama-${var.prefix}cluster-vnet"
  resource_group_name = "${var.prefix}-hcs-mrg"
}