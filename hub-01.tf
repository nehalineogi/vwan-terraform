
locals {
  prefix-hub-01         = "hub-01"
  hub-01-location       = "EastUS"
  hub-01-resource-group = "vwan-rg"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}
resource "azurerm_virtual_hub" "hub-01" {
  name                = "${local.prefix-hub-01}-${local.hub-location}"
  resource_group_name = "${local.hub-01-resource-group}"
  location            = "${local.hub-01-location}"
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "172.16.0.0/16"
}

#
# VPN Gateway
#
resource "azurerm_vpn_gateway" "hub01-vpn-gw" {
  name                = "${local.prefix-hub-01}-vpn-gw"
  resource_group_name = "${local.hub-01-resource-group}"
  location            = "${local.hub-01-location}"
  virtual_hub_id      = azurerm_virtual_hub.hub-01.id
}

#
# Connection
# https://www.terraform.io/docs/providers/azurerm/r/virtual_hub_connection.html
#
resource "azurerm_virtual_hub_connection" "spoke1-conn" {
  name                      = "${local.prefix-hub-01}-spoke1-conn"
  virtual_hub_id            = azurerm_virtual_hub.hub-01.id
  remote_virtual_network_id = azurerm_virtual_network.spoke1-vnet.id
  hub_to_vitual_network_traffic_allowed          = true
  vitual_network_to_hub_gateways_traffic_allowed = false
  internet_security_enabled                      = true
 depends_on = [azurerm_virtual_network.spoke1-vnet,azurerm_vpn_gateway.hub01-vpn-gw]
}

resource "azurerm_virtual_hub_connection" "spoke2-conn" {
  name                      = "${local.prefix-hub-01}-spoke2-conn"
  virtual_hub_id            = azurerm_virtual_hub.hub-01.id
  remote_virtual_network_id = azurerm_virtual_network.spoke2-vnet.id
  hub_to_vitual_network_traffic_allowed          = true
  vitual_network_to_hub_gateways_traffic_allowed = false
  internet_security_enabled                      = true
 depends_on = [azurerm_virtual_network.spoke2-vnet,azurerm_vpn_gateway.hub01-vpn-gw]
}
