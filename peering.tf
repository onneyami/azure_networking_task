resource "azurevm_virtual_network_peering" "app_to_hub" {
  name                = "app-vnet-to-hub-vnet"
  resource_group_name = data.azurevm_resource_group.rg.name
  virtual_network_name = azurevm_virtual_network.vnet_app.name
  remote_virtual_network_id = azurevm_virtual_network.vnet_hub.id
}

resource "azurevm_virtual_network_peering" "hub_to_app" {
  name                = "hub-vnet-to-app-vnet"
  resource_group_name = data.azurevm_resource_group.rg.name
  virtual_network_name = azurevm_virtual_network.vnet_hub.name
  remote_virtual_network_id = azurevm_virtual_network.vnet_app.id
}
