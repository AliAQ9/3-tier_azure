resource "azurerm_resource_group" "azure-task" {
  name     =    var.name
  location =    var.location
}

resource "azurerm_network_security_group" "ssh-secg" {
  name                = "ssh-secg"
  location            = var.location
  resource_group_name = var.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "0.0.0.0/0"
  }
}

resource "azurerm_network_security_group" "http-secg" {
  name                = "http-secg"
  location            = var.location
  resource_group_name = var.name

  security_rule {
    name                       = "HTTP"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "0.0.0.0/0"
  }
}

resource "azurerm_network_security_group" "https-secg" {
  name                = "https-secg"
  location            = var.location
  resource_group_name = var.name

  security_rule {
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "443"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "0.0.0.0/0"
  }
}

resource "azurerm_network_security_group" "mysql-secg" {
  name                = "mysql-secg"
  location            = var.location
  resource_group_name = var.name

  security_rule {
    name                       = "MYSQL"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3306"
    destination_port_range     = "3306"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "0.0.0.0/0"
  }
}