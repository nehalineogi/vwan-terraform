
locals {
  prefix-hub-01         = "hub-01"
  hub-01-location       = "eastus2"
  
}
resource "azurerm_virtual_hub" "hub-01" {
  name                = "${local.prefix-hub-01}-${local.hub-01-location}"
 // resource_group_name = "${local.hub-01-resource-group}"
  resource_group_name = azurerm_virtual_wan.vwan.resource_group_name
  location            = "${local.hub-01-location}"
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "172.16.0.0/16"
}

#
# VPN Gateway
#
/*
resource "azurerm_vpn_gateway" "hub01-vpn-gw" {
  name                = "${local.prefix-hub-01}-vpn-gw"
  resource_group_name = "${local.hub-01-resource-group}"
  location            = "${local.hub-01-location}"
  virtual_hub_id      = azurerm_virtual_hub.hub-01.id
}
*/

#
# P2S VPN Gateway
#

resource "azurerm_vpn_server_configuration" "hub01-vpn-server" {
  name                = "${local.prefix-hub-01}-vpn-server"
 // resource_group_name = "${local.hub-01-resource-group}"
  resource_group_name = azurerm_resource_group.vwan-rg.name
  location            = "${local.hub-01-location}"
  vpn_authentication_types = ["Certificate"]

  client_root_certificate {
    name             = "Self-Signed-Root-CA"
    public_cert_data = <<EOF
MIIFazCCA1OgAwIBAgIUOvQnt+TrV4wSLccW0qk+D0xg40EwDQYJKoZIhvcNAQEL
BQAwRTELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAk1BMRIwEAYDVQQKDAlNeUNvbXBh
bnkxFTATBgNVBAMMDG15ZG9tYWluLmNvbTAeFw0yMDA2MjQxMzA2MDdaFw0yMzA0
MTQxMzA2MDdaMEUxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJNQTESMBAGA1UECgwJ
TXlDb21wYW55MRUwEwYDVQQDDAxteWRvbWFpbi5jb20wggIiMA0GCSqGSIb3DQEB
AQUAA4ICDwAwggIKAoICAQCzxHfMaNyf1UTB+qWBLEhbBzW5XpkzficPag5NqgoE
WiD6XzWsf3vriDuWebNeGhbfDzrAKId1NYScFhzibvupLNaCdlMJxPvscUR5DNvK
UMw7u7znJiP2EE8Rmrmh/JVQ00JJcJDvyw4N0JYjYWovXU8Q2xEPHV7bFQL818Oi
4pjfyod53m3jmOLQ+8KI31WVwLc1ptLc+PqcVFGtBA31byZo07oF/zyCxnNJNdER
P2RDRQVQSs5rpuW7SN3r+RkFGWehMjFyPl57vs67uFmFWB7lzHqVHZpK5y4wJFkg
r8AoN9p+/hqUUcl1tlGKLl5hCtfzKL/jvou99rPKtcmncEwS8dCgVv44Qu1uhMZb
qj5wVnteLps2DaL1ZmLxeuz1mAqMYNo791TbRyQdJraQMOFwyAxDrrfUVpEK/8TQ
E/Srg24Rl1r8TjiSg6Xl0bxLe/dvVFzLEZHD0C1XnXxQAEWZzbeNzr9RELzrxbPr
b21L8x3oOUww7/8FM3kADx2TxWaOz0daNCoY5qs7Dfn4FrZcImx1+2NEsooeQK+c
l9aOrwMdyWokZ4Xq+lD9EDG4rkGUG1OgYoMuLrA/x/q6COwzfmhfOESNebIoFMv9
MWkzenuRfhnrLsEQjSH+hSjyuh1nlStoI0Vwqj1CK8j419AasCaicVgcl4WqZl9v
RwIDAQABo1MwUTAdBgNVHQ4EFgQUzVe5yw15X92zc+g8Q44Bo5RuKA4wHwYDVR0j
BBgwFoAUzVe5yw15X92zc+g8Q44Bo5RuKA4wDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAgEAMTjeduJixUf7Q8VcUH7JMj+nRJXufag9oVTcIseo+cRd
pQhO09y6S+JU3yli0bVHmIZJw9SDq7MiSERHFNzPQrsq/AwBF+xXedDvwzrXjiHW
lpE1eg8nA4cmMXdMgBko/s+oQdoJQKrhjCvtWlAHB6zaelHYqVIIaw2P1Na30J2M
F/JIWMX8RJ7znQnkLO72+INYu6vgq+n4g7ZGZE9jQuovlPEySnKxu0D/1eCEiNew
kQZWmuy+z2s5W635gmdHrC/TPGaQZMYWgwAWFufCQmyocPDcUpwuJXPQ3OQAHFm1
bW/yaytbqQUMMOTJoHkb1ts3Bns3+s31xDuOCysTvmo8VsAWl7nzG1haW2r/SQ53
DuAKk+ZM3c1RcbgymEWCYyHF+93WaAJpFy7q4xKYr8eLZmOUUUb2urNck7OCMWmy
zX8+bVvuO1z16N0ZtSXp9SROpgLyC7cz+S4S5nsI+OFB5ZzxiE7e2vVpyTvN1Izu
lj9iLxdQgCS3HSd7qQJyY1XpJA7V1TDMkkd2lQbtYDk4ldkWAKa4cQ0yubI8keT4
Ee7Uc3UG2Y26NqlDyefU0otHIFE1Qz3BwELq9h//lE7rp3UHIzMeFdoqr8mmOc0K
8QNbN1h6WzBle66Gx/D9S1ndysU36U7vsMEL6m4Kv6qral2PzDHBMiFAqSciAzw=
EOF
  }
  depends_on = [ azurerm_virtual_hub.hub-01]
}

resource "azurerm_point_to_site_vpn_gateway" "hub01-p2s-gw" {
 name                = "${local.prefix-hub-01}-p2s-gw"
  //resource_group_name = "${local.hub-01-resource-group}"
  resource_group_name = azurerm_resource_group.vwan-rg.name
  location            = "${local.hub-01-location}"
  virtual_hub_id      = azurerm_virtual_hub.hub-01.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.hub01-vpn-server.id
  scale_unit                  = 1

  connection_configuration {
     name                = "${local.prefix-hub-01}-p2s-gw-conn"
     vpn_client_address_pool {
     address_prefixes    = ["192.168.51.0/24"]
  }
  }
  depends_on = [ azurerm_virtual_hub.hub-01,azurerm_vpn_server_configuration.hub01-vpn-server]
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
    depends_on = [ azurerm_virtual_hub.hub-01]
}

resource "azurerm_virtual_hub_connection" "spoke2-conn" {
  name                      = "${local.prefix-hub-01}-spoke2-conn"
  virtual_hub_id            = azurerm_virtual_hub.hub-01.id
  remote_virtual_network_id = azurerm_virtual_network.spoke2-vnet.id
  hub_to_vitual_network_traffic_allowed          = true
  vitual_network_to_hub_gateways_traffic_allowed = false
  internet_security_enabled                      = true
    depends_on = [ azurerm_virtual_hub.hub-01]
}
