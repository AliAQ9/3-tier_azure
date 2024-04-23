data "azurerm_client_config" "current" {
}

data "azuread_service_principal" "example" {
  display_name = ""
}

data "azurerm_subnet" "example" {
  name                 = "backend"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.name
}