resource "azurevm_virtual_network" "vnet_hub" {
  name                = "vnet-hub"
  resource_group_name = data.azurevm_resource_group.rg.name
  location            = data.azurevm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurevm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurevm_resource_group.rg.name
  virtual_network_name = azurevm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.0.1.0/26"]
}