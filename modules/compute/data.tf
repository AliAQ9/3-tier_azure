data "azurerm_subnet" "websubid" {
  name                 = "backend"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.name
}

output "subnet_id" {
  value = data.azurerm_subnet.websubid.id
}