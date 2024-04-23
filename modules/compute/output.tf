output "web_subnet_id" {
  value = data.azurerm_subnet.websubid.id
}

output "app_subnet_id" {
  value = data.azurerm_subnet.appsubid.id
}