data "azurerm_client_config" "current" {
}

data "azuread_service_principal" "example" {
  display_name = ""
}