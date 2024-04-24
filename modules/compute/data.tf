data "azurerm_subnet" "websubid" {
  name                 = "websubid"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.name
}

data "azurerm_subnet" "appsubid" {
  name                 = "appsubid"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.name
}

data  "web-secg" "id" {
  name = "web-secg"
  virtual_network_name = var.vnet_name
  resource_group_name = var.name
}

