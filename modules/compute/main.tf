resource "azurerm_resource_group" "azure_project" {
  name     = var.name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "websub" {
  name                 = var.websubnetname
  resource_group_name  = var.name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.websubnetcidr
}

resource "azurerm_network_interface" "web-net-interface" {
  name                = "web-net-interface"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.websubid.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "pip"
  resource_group_name = var.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_linux_virtual_machine" "webserver" {
  name                = var.web_host_name
  resource_group_name = var.name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = var.web_username
  network_interface_ids = [
    azurerm_network_interface.web-net-interface
  ]
 
  admin_ssh_key {
    username   = var.web_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "bansirllc1619470302579"
    offer     = "006-com-centos-9-stream"
    sku       = "id-product-plan-centos-idstream"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "web-secg" {
  name                = "web-secg"
  location            = var.location
  resource_group_name = var.name

  security_rule {
    name                       = "HTTP"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "0.0.0.0/0"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "443"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "0.0.0.0/0"
  }
}

resource "azurerm_subnet_network_security_group_association" "web-secg" {
  subnet_id                 = data.azurerm_subnet.websubid.id
  network_security_group_id = data.azurerm_network_security_group.web-secg.id
}

##### APP SERVER #####

resource "azurerm_network_interface" "app-net-interface" {
  name                = "app-net-interface"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name = ""
    subnet_id = data.azurerm_subnet.appsubid.id
    private_ip_address_allocation = "Dyamic"
  }
}

resource "azurerm_linux_virtual_machine" "appserver" {
  name                = var.app_host_name
  resource_group_name = var.name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = var.app_username
  network_interface_ids = [
    azurerm_network_interface.app-net-interface
  ]
 
  admin_ssh_key {
    username   = var.app_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "bansirllc1619470302579"
    offer     = "006-com-centos-9-stream"
    sku       = "id-product-plan-centos-idstream"
    version   = "latest"
  }
}