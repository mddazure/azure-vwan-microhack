provider "azurerm" {
  features {}
}
#######################################################################
## Create Resource Group
#######################################################################

resource "azurerm_resource_group" "vwan-microhack-spoke-rg" {
  name     = "vwan-microhack-spoke-rg"
  location = var.location-spoke-1
 tags = {
    environment = "spoke"
    deployment  = "terraform"
    microhack    = "vwan"
  }
}

resource "azurerm_resource_group" "vwan-microhack-hub-rg" {
  name     = "vwan-microhack-hub-rg"
  location = var.location-vwan
 tags = {
    environment = "hub"
    deployment  = "terraform"
    microhack    = "vwan"
  }
}
