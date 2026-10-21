resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                      = "app-vnet-to-hub-vnet"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = data.azurerm_virtual_network.app_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_hub.id
}

resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                      = "hub-vnet-to-app-vnet"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id = data.azurerm_virtual_network.app_vnet.id
}