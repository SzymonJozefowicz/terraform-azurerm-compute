provider "azurerm" {
  features {}
}

// One Public IP per instance

resource "azurerm_public_ip" "this" {
  count                 = var.number_of_instances
  name                  = "${var.prefix}-${count.index}-pip"
  resource_group_name   = var.resource_group_name
  location              = var.location
  allocation_method     = var.public_ip_allocation_method
   
}

// One Netwok card per instance
resource "azurerm_network_interface" "this" {
  count                 = var.number_of_instances
  name                  = "${var.prefix}-${count.index}-nic"
  resource_group_name   = var.resource_group_name
  location              = var.location
  
  ip_configuration {
    name                            = "ipconfiguration"
    subnet_id                       = var.subnet_id
    private_ip_address_allocation   = var.private_ip_address_allocation
    // public_ip_address_id            = azurerm_public_ip.this.id
    public_ip_address_id            = element(azurerm_public_ip.this.*.id,count.index)
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  count                     = var.number_of_instances
  network_interface_id      = element(azurerm_network_interface.this.*.id,count.index)
  network_security_group_id = var.network_security_group_id
}


resource "azurerm_virtual_machine" "this" {
  count                 = var.number_of_instances
  name                  = "${var.prefix}-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [element(azurerm_network_interface.this.*.id,count.index)]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  plan {
    name      = var.plan_name
    publisher = var.plan_publisher
    product   = var.plan_product
  }

  storage_os_disk {
    name              = "${var.prefix}${count.index}-osdisk"
    caching           = var.caching
    create_option     = var.create_option
    managed_disk_type = var.os_disk_managed_disk_type
  }

  dynamic storage_data_disk {
    for_each = range(var.data_disk_count)
    content {
      name              = "${var.prefix}-datadisk-${count.index}"
      create_option     = "Empty"
      lun               = count.index
      disk_size_gb      = var.data_disk_size_gb
      managed_disk_type = var.data_disk_managed_disk_type
    }
  }


  os_profile {
    computer_name  = "${var.prefix}${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}