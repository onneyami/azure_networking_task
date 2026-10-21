data "azurerm_virtual_network" "app_vnet" {
  name                = "app-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group_template_deployment.lab_vms]
}

data "azurerm_subnet" "backend" {
  name                 = "backend"
  virtual_network_name = "app-vnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group_template_deployment.lab_vms]
}