resource "azurerm_resource_group" "azure_project" {
  name     = "azure-project"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.azure_project.location
  resource_group_name = azurerm_resource_group.azure_project.name
  address_space       = ["10.0.0.0/16"]
}
/*
resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_cidrs)
  name                 = "subnet${count.index}"
  resource_group_name  = azurerm_resource_group.azure_project.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidrs[count.index]]
}

resource "azurerm_network_security_group" "nsg" {
  count               = length(var.subnet_cidrs)
  name                = "nsg${count.index}"
  location            = azurerm_resource_group.azure_project.location
  resource_group_name = azurerm_resource_group.azure_project.name
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = length(var.subnet_cidrs)
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
  instances            = 2
  overprovision        = true
  zone_balance         = true
  zones                = [1, 2, 3]
  upgrade_mode         = "Automatic"
  admin_username       = "valentinabalan"
  user_data            = base64encode(file("./webserver.sh"))

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
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
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

resource "azurerm_monitor_autoscale_setting" "default" {
  name                = "autoscale"
  resource_group_name = azurerm_resource_group.azure_project.name
  location            = azurerm_resource_group.azure_project.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id
  profile {
    name = "AutoScale"
    capacity {
      default = 2
      minimum = 2
      maximum = 5
    }
    rule {
      metric_trigger {
        metric_name        = "CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 20
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
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

resource "azurerm_lb_probe" "http" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "httpprobe"
  port                = 80
  protocol            = "Tcp"
  interval_in_seconds = 5
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_public_ip.pip.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb.id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_lb_rule" "https" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "https"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_public_ip.pip.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb.id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_public_ip" "pip" {
  name                = "pip"
  resource_group_name = azurerm_resource_group.azure_project.name
  location            = azurerm_resource_group.azure_project.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

*/
