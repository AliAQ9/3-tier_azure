resource "azurerm_resource_group" "azure_project" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.azure_project.location
  resource_group_name = azurerm_resource_group.azure_project.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "public" {
  count                = length (var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.Team2.name
  virtual_network_name = azurerm_virtual_network.Team2VPC.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
}


resource "azurerm_network_security_group" "nsg" {
  count               = length(var.subnet_security_groups)
  name                = var.subnet_security_groups[count.index]
  location            = azurerm_resource_group.azure_project.location
  resource_group_name = azurerm_resource_group.azure_project.name
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = length
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[count.index].id
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.azure_project.name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                 = "vmss"
  computer_name_prefix = "vm"
  resource_group_name  = azurerm_resource_group.azure_project.name
  location             = azurerm_resource_group.azure_project.location
  sku                  = "Standard_B2ms"
  instances            = 1
  overprovision        = true
  zone_balance         = true
  zones                = [1, 2, 3]
  upgrade_mode         = "Automatic"
  admin_username       = "valentinabalan"
  user_data            = base64encode(file("webserver.sh"))

  rolling_upgrade_policy {
    max_batch_instance_percent              = 50
    max_unhealthy_instance_percent          = 50
    max_unhealthy_upgraded_instance_percent = 0
    pause_time_between_batches              = "PT0S"
  }

  admin_ssh_key {
    username   = "valentinabalan"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "bansirllc1619470302579"
    offer     = "006-com-centos-9-stream"
    sku       = "id-product-plan-centos-idstream"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "project-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet[0].id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb.id]
    }
  }
}

resource "azurerm_lb" "lb" {
  name                = "loadbalancer"
  location            = azurerm_resource_group.azure_project.location
  resource_group_name = azurerm_resource_group.azure_project.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = azurerm_public_ip.pip.name
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backendpool"
}

resource "azurerm_public_ip" "pip" {
  name                = "pip"
  resource_group_name = azurerm_resource_group.azure_project.name
  location            = azurerm_resource_group.azure_project.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm"
  resource_group_name = azurerm_resource_group.azure_project.name
  location            = azurerm_resource_group.azure_project.location
  size                = "Standard_B1ls"
  admin_username      = "valentinabalan"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
 
  admin_ssh_key {
    username   = "valentinabalan"
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

resource "azurerm_network_interface" "nic" {
  name                = "project-nic"
  location            = azurerm_resource_group.azure_project.location
  resource_group_name = azurerm_resource_group.azure_project.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id      = azurerm_public_ip.pip.id
  }
}