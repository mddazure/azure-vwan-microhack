#######################################################################
## Create VNET Gateway - onprem
#######################################################################
resource "azurerm_public_ip" "vnet-gw-onprem-pubip" {
    name                = "vnet-gw-onprem-pubip"
    location            = var.location-onprem
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Dynamic"
    sku                 = "Basic"
  }
  
  resource "azurerm_virtual_network_gateway" "vnet-gw-onprem" {
    name                = "vnet-gw-onprem"
    location            = var.location-onprem
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  
    type     = "Vpn"
    vpn_type = "RouteBased"
  
    active_active = false
    enable_bgp    = true
    sku           = "VpnGw1"
  
    bgp_settings{
      asn = 64512
}

    ip_configuration {
      name                          = "vnet-gw-onprem-ip-config"
      public_ip_address_id          = azurerm_public_ip.vnet-gw-onprem-pubip.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.onprem-gateway-subnet.id
    }
  }