output "web_subnet_id" {
  value = data.azurerm_subnet.websubid.id
}

output "app_subnet_id" {
  value = data.azurerm_subnet.appsubid.id
}

output "" {
  value = data.azurerm_network_security_group.web-secg
}