#######################################################################
## Create Bastion spoke-1
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-1-pubip" {
  name                = "bastion-spoke-1-pubip"
  location            = var.location-spoke-1
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-1" {
  name                = "bastion-spoke-1"
  location            = var.location-spoke-1
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-spoke-1-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-1-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-1-pubip.id
  }
}
#######################################################################
## Create Bastion spoke-2
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-2-pubip" {
  name                = "bastion-spoke-2-pubip"
  location            = var.location-spoke-2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-2" {
  name                = "bastion-spoke-2"
  location            = var.location-spoke-2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-spoke-2-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-2-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-2-pubip.id
  }
}
#######################################################################
## Create Bastion spoke-3
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-3-pubip" {
  name                = "bastion-spoke-3-pubip"
  location            = var.location-spoke-3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-3" {
  name                = "bastion-spoke-3"
  location            = var.location-spoke-3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-spoke-3-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-3-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-3-pubip.id
  }
}
#######################################################################
## Create Bastion spoke-4
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-4-pubip" {
  name                = "bastion-spoke-4-pubip"
  location            = var.location-spoke-4
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-4" {
  name                = "bastion-spoke-4"
  location            = var.location-spoke-4
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-spoke-4-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-4-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-4-pubip.id
  }
}
#######################################################################
## Create Bastion onprem
#######################################################################
resource "azurerm_public_ip" "bastion-onprem-pubip" {
  name                = "bastion-onprem-pubip"
  location            = var.location-onprem
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-onprem" {
  name                = "bastion-onprem"
  location            = var.location-onprem
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-onprem-configuration"
    subnet_id            = azurerm_subnet.bastion-onprem-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-onprem-pubip.id
  }
}
#######################################################################
## Create Bastion onprem2
#######################################################################
resource "azurerm_public_ip" "bastion-onprem2-pubip" {
  name                = "bastion-onprem2-pubip"
  location            = var.location-onprem2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-onprem2" {
  name                = "bastion-onprem2"
  location            = var.location-onprem2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-onprem2-configuration"
    subnet_id            = azurerm_subnet.bastion-onprem2-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-onprem2-pubip.id
  }
}
#######################################################################
## Create Bastion Services
#######################################################################
resource "azurerm_public_ip" "bastion-services-pubip" {
  name                = "bastion-services-pubip"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-services" {
  name                = "bastion-services"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-services-configuration"
    subnet_id            = azurerm_subnet.bastion-services-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-services-pubip.id
  }
}
#######################################################################
## Create Bastion NVA
#######################################################################
resource "azurerm_public_ip" "bastion-nva-pubip" {
  name                = "bastion-services-nva"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-nva" {
  name                = "bastion-nva"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  sku                 = "Standard"
  ip_connect_enabled =  true

  ip_configuration {
    name                 = "bastion-nva-configuration"
    subnet_id            = azurerm_subnet.bastion-nva-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-nva-pubip.id
  }
}