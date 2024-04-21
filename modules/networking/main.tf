resource "azurerm_resource_group" "azure_project" {
  name     = var.name
  location = var.location
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
}


resource "azurerm_network_security_group" "vnet-secg" {
  name                = "vnet-secg"
  location            = var.location
  resource_group_name = var.name
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

data "azurerm_client_config" "current" {
}

data "azuread_service_principal" "example" {
  display_name = ""
}

 resource "azurerm_lb" "TestLoadBalancer" {
 name                = "TestLoadBalancer"
 location            = var.location
 resource_group_name = var.name
}

resource "azurerm_public_ip" "PublicIP" {
 name                = "PublicIP"
location            = var.location
resource_group_name = var.name
 allocation_method   = "Static"
}

resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
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

  tags = {
    environment = "Production"
  }
}