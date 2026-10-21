resource "azurevm_virtual_network" "vnet_hub" {
  name                = "vnet-hub"
  resource_group_name = data.azurevm_resource_group.rg.name
  location            = data.azurevm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}