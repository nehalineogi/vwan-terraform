locals {
  spoke3-location       = "CentralUS"
  spoke3-resource-group = "spoke3-vnet-rg"
  prefix-spoke3         = "spoke3"
}

resource "azurerm_resource_group" "spoke3-vnet-rg" {
  name     = local.spoke3-resource-group
  location = local.spoke3-location
}

resource "azurerm_virtual_network" "spoke3-vnet" {
  name                = "spoke3-vnet"
  location            = azurerm_resource_group.spoke3-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke3-vnet-rg.name
  address_space       = ["10.3.0.0/16"]

  tags = {
    environment = local.prefix-spoke3
  }
}

resource "azurerm_subnet" "spoke3-mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.spoke3-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke3-vnet.name
  address_prefix       = "10.3.1.0/24"
}

resource "azurerm_subnet" "spoke3-workload" {
  name                 = "workload"
  resource_group_name  = azurerm_resource_group.spoke3-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke3-vnet.name
  address_prefix       = "10.3.2.0/24"
}

resource "azurerm_network_interface" "spoke3-nic" {
  name                 = "${local.prefix-spoke3}-nic"
  location             = azurerm_resource_group.spoke3-vnet-rg.location
  resource_group_name  = azurerm_resource_group.spoke3-vnet-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-spoke3
    subnet_id                     = azurerm_subnet.spoke3-mgmt.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "spoke3-vm" {
  name                  = "${local.prefix-spoke3}-vm"
  location              = azurerm_resource_group.spoke3-vnet-rg.location
  resource_group_name   = azurerm_resource_group.spoke3-vnet-rg.name
  network_interface_ids = [azurerm_network_interface.spoke3-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-spoke3}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = local.prefix-spoke3
  }
}