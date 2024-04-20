resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_cidrs)
  name                 = "subnet${count.index}"
  resource_group_name  = azurerm_resource_group.azure_project.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidrs[count.index]]
}