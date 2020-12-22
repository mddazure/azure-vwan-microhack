 
  resource "azurerm_virtual_wan" "microhack-vwan" {
    name                = "microhack-vwan"
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    location            = var.location-vwan
  }
  
  resource "azurerm_virtual_hub" "microhack-we-hub" {
    name                = "microhack-we-hub"
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    location            = var.location-vwan-we-hub
    virtual_wan_id      = azurerm_virtual_wan.microhack-vwan.id
    address_prefix      = "192.168.0.0/24"
  }
  
  resource "azurerm_vpn_gateway" "microhack-we-hub-vng" {
    name                = "microhack-we-hub-vng"
    location            = var.location-vwan-we-hub
    resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
    virtual_hub_id      = azurerm_virtual_hub.microhack-we-hub.id
  }