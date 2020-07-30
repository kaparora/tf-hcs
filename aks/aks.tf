resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.hcs.name
  dns_prefix          = "${var.prefix}aks"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = var.vm_size
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    owner = "${var.email}"
  }
}