resource "azurerm_resource_group" "azure-task" {
  name     =    var.name
  location =    var.location
}

resource "azurerm_network_security_group" "ssh_secg" {
  name                = "ssh_secg"
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

resource "azurerm_resource_group" "azure-task" {
  name     =    var.name
  location =    var.location
}

resource "azurerm_network_security_group" "http_secg" {
  name                = "http_secg"
  location            = var.location
  resource_group_name = var.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "0.0.0.0/0"
  }
}