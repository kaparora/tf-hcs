# Create virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.hcs.name
  network_interface_ids = ["${azurerm_network_interface.vm_nic.id}"]
  vm_size               = var.vm_size

  identity {
    type = "SystemAssigned"
  }

  storage_os_disk {
    name              = "OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-vm"
    admin_username = "azureuser"
    custom_data    = base64encode("${data.template_file.vm_setup.rendered}")
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = var.public_key
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.storageaccount.primary_blob_endpoint
  }

  tags = {
    owner = "${var.email}"
  }
}