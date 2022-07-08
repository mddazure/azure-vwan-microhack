#######################################################################
## Create VNET Gateway - onprem
#######################################################################
resource "azurerm_public_ip" "vnet-gw-onprem2-pubip-1" {
    name                = "vnet-gw-onprem2-pubip-1"
    location            = var.location-onprem2
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = ["1","2","3"]    
  }
  
  resource "azurerm_public_ip" "vnet-gw-onprem2-pubip-2" {
    name                = "vnet-gw-onprem2-pubip-2"
    location            = var.location-onprem2
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
    zones               = ["1","2","3"]    
  }
  resource "azurerm_virtual_network_gateway" "vnet-gw-onprem2" {
    name                = "vnet-gw-onprem2"
    location            = var.location-onprem2
    resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  
    type     = "Vpn"
    vpn_type = "RouteBased"
  
    active_active = true
    enable_bgp    = true
    sku           = "VpnGw1AZ"
  
    bgp_settings{
      asn = 64001
    } 

    ip_configuration {
      name                          = "vnet-gw-onprem2-ip-config-1"
      public_ip_address_id          = azurerm_public_ip.vnet-gw-onprem2-pubip-1.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.onprem2-gateway-subnet.id
    }
    ip_configuration {
      name                          = "vnet-gw-onprem2-ip-config-2"
      public_ip_address_id          = azurerm_public_ip.vnet-gw-onprem2-pubip-2.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = azurerm_subnet.onprem2-gateway-subnet.id
    }
  }