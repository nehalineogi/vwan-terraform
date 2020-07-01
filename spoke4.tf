locals {
  spoke4-location       = "CentralUS"
  spoke4-resource-group = "spoke4-vnet-rg"
  prefix-spoke4         = "spoke4"
}

resource "azurerm_resource_group" "spoke4-vnet-rg" {
  name     = local.spoke4-resource-group
  location = local.spoke4-location
}

resource "azurerm_virtual_network" "spoke4-vnet" {
  name                = "spoke4-vnet"
  location            = azurerm_resource_group.spoke4-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke4-vnet-rg.name
  address_space       = ["10.4.0.0/16"]

  tags = {
    environment = local.prefix-spoke4
  }
}

resource "azurerm_subnet" "spoke4-mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.spoke4-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke4-vnet.name
  address_prefix       = "10.4.1.0/24"
}

resource "azurerm_subnet" "spoke4-workload" {
  name                 = "workload"
  resource_group_name  = azurerm_resource_group.spoke4-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke4-vnet.name
  address_prefix       = "10.4.2.0/24"
}

resource "azurerm_network_interface" "spoke4-nic" {
  name                 = "${local.prefix-spoke4}-nic"
  location             = azurerm_resource_group.spoke4-vnet-rg.location
  resource_group_name  = azurerm_resource_group.spoke4-vnet-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-spoke4
    subnet_id                     = azurerm_subnet.spoke4-mgmt.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "spoke4-vm" {
  name                  = "${local.prefix-spoke4}-vm"
  location              = azurerm_resource_group.spoke4-vnet-rg.location
  resource_group_name   = azurerm_resource_group.spoke4-vnet-rg.name
  network_interface_ids = [azurerm_network_interface.spoke4-nic.id]
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
    computer_name  = "${local.prefix-spoke4}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = local.prefix-spoke4
  }
}