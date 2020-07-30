
resource "azurerm_virtual_network" "aks" {
  name                = "${var.prefix}-aks-vnet"
  address_space       = ["${var.aks_vnet_cidr}"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.hcs.name
  tags = {
    owner = "${var.email}"
  }
}

resource "azurerm_subnet" "aks" {
  name                 = "${var.prefix}-aks-subnet"
  resource_group_name  = data.azurerm_resource_group.hcs.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["${var.aks_vnet_cidr}"]
}


resource "azurerm_virtual_network_peering" "toaks" {
  name                      = "hcstoaks"
  resource_group_name       = data.azurerm_resource_group.hcs.name
  virtual_network_name      = azurerm_virtual_network.aks.name
  remote_virtual_network_id = data.azurerm_virtual_network.hcs.id
}

resource "azurerm_virtual_network_peering" "fromaks" {
  name                      = "akstohcs"
  resource_group_name       = data.azurerm_virtual_network.hcs.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hcs.name
  remote_virtual_network_id = azurerm_virtual_network.aks.id
}

data "azurerm_virtual_network" "hcs" {
  name                = "hvn-consul-ama-${var.prefix}cluster-vnet"
  resource_group_name = "${var.prefix}-hcs-mrg"
}