resource "azurerm_network_security_group" "app_vnet_nsg" {
  name                = "app-vnet-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                                       = "AllowSSH"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.app_frontend_asg.id]
  }
}

resource "azurerm_subnet_network_security_group_association" "backend_nsg" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.app_vnet_nsg.id
}