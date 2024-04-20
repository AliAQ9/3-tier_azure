 resource "azurerm_lb" "TestLoadBalancer" {
 name                = "TestLoadBalancer"
 location            = "Central US"
 resource_group_name = azurerm_resource_group.azure_project.name
}

resource "azurerm_public_ip" "PublicIP" {
 name                = "PublicIP"
location            = "Central US"
resource_group_name = azurerm_resource_group.azure_project.name
 allocation_method   = "Static"
}
