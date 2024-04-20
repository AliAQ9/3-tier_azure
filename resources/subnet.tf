resource "azurerm_resource_group" "azure_project" {
  name     = "azure-project"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.1.0/16"]
  location            = azurerm_resource_group.azure_project
  resource_group_name = azurerm_resource_group.azure_project
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.2.0/16"]
  location            = azurerm_resource_group.azure_project
  resource_group_name = azurerm_resource_group.azure_project
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.3.0/16"]
  location            = azurerm_resource_group.azure_project
  resource_group_name = azurerm_resource_group.azure_project
}
