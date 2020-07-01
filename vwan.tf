locals {
  prefix-hub         = "vwan"
  hub-location       = "EastUS2"
  hub-resource-group = "vwan-rg" 
}

resource "azurerm_resource_group" "vwan-rg" {
  name              = "${local.hub-resource-group}"
  location          = "${local.hub-location}"
}

resource "azurerm_virtual_wan" "vwan" {
  name                = "${local.prefix-hub}"
  resource_group_name = azurerm_resource_group.vwan-rg.name
  location            = azurerm_resource_group.vwan-rg.location
  #allow_vnet_to_vnet_traffic = true
}