resource "azurerm_public_ip" "vm" {
  name                = "${var.prefix}-vm-ip"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.hcs.name
  allocation_method   = "Dynamic"

  tags = {
    owner = "${var.email}"
  }
}