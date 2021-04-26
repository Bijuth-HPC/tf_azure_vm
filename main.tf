locals {
  virtual_machine_name = "${var.prefix}-vm"
}

provider "azurerm" {
  version = "=2.16.0"
  features {}
}

resource "azurerm_linux_virtual_machine" "tf_vm" {
  name                  = "nc6sdsvm"
  resource_group_name   = azurerm_resource_group.tf_vm_rg.name
  location              = azurerm_resource_group.tf_vm_rg.location
  network_interface_ids = [azurerm_network_interface.tf_vm_nic.id]
  size                  = var.machine_type

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "Microsoft-dsvm"
    offer     = "ubuntu-1804"
    sku       = "1804-gen2"
    version   = "latest"
  }

  os_disk {
    name              = "${local.virtual_machine_name}-osdisk"
    disk_size_gb      = var.os_disk_size_gb
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username      = var.tf_vm_username
  admin_ssh_key {
    username   = var.tf_vm_username
    public_key = var.tf_vm_user_publickey
  }
}
