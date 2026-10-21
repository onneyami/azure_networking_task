resource "azurevm_virtual_network" "vnet_app" {
  name                = "vnet-app"
  resource_group_name = data.azurevm_resource_group.rg.name
  location            = data.azurevm_resource_group.rg.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurevm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = data.azurevm_resource_group.rg.name
  virtual_network_name = azurevm_virtual_network.vnet_app.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurevm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = data.azurevm_resource_group.rg.name
  virtual_network_name = azurevm_virtual_network.vnet_app.name
  address_prefixes     = ["10.1.1.0/24"]
}