resource "azurerm_storage_account" "storageaccount" {
  name                     = "sa${random_id.sa.hex}"
  resource_group_name      = data.azurerm_resource_group.hcs.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    owner = "${var.email}"
  }
}

resource "random_id" "sa" {
  byte_length = 6
}