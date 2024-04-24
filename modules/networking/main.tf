provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure_project" {
  name     = var.name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = var.location
  resource_group_name = var.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web-subnet" {
  name                 = "web-subnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.name
  address_prefixes     = [var.websubnetcidr]
}

resource "azurerm_subnet" "app-subnet" {
  name                 = "app-subnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.name
  address_prefixes     = [var.appsubnetcidr]
}

resource "azurerm_subnet" "db-subnet" {
  name                 = "db-subnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.var.name
  address_prefixes     = [var.dbsubnetcidr]
}

resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                   = random_id.server.hex
  resource_group_name    = var.name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = random_id.server.hex
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  }

  resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}

  resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                 = "vmss"
  computer_name_prefix = "vm"
  resource_group_name  = var.name
  location             = var.location
  sku                  = "Standard_B2ms"
  instances            = 1
  overprovision        = true
  zone_balance         = true
  zones                = [1, 2, 3]
  upgrade_mode         = "Automatic"
  admin_username       = var.web_host_name
  user_data            = base64encode(file("webserver.sh"))

  rolling_upgrade_policy {
    max_batch_instance_percent              = 50
    max_unhealthy_instance_percent          = 50
    max_unhealthy_upgraded_instance_percent = 0
    pause_time_between_batches              = "PT0S"
  }

  admin_ssh_key {
    username   = var.web_username
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
    name    = data.azurerm_network_interface.web-net-interface
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.websubnetcidr
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb.id]
    }
  }
}

resource "azurerm_lb" "lb" {
  name                = "loadbalancer"
  location            = var.location
  resource_group_name = var.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = azurerm_public_ip.pip.name
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "pip"
  resource_group_name = var.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb_backend_address_pool" "lb" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backendpool"
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "keyvault"
  location                    = var.location
  resource_group_name         = var.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
}

resource "azurerm_network_security_group" "vnet-secg" {
  name                = "vnet-secg"
  location            = var.location
  resource_group_name = var.name
   security_rule {
    name                       = "vnet-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

    resource  "azure_key_vault_access_policy" "keyvault" {
    key_vault_id = "azurerm_key_vault.keyvault"
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }