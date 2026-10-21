resource "azurerm_application_security_group" "app_frontend_asg" {
  name                = "app-frontend-asg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_network_interface" "vm1_nic" {
  name                = "vm1-nic"
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group_template_deployment.lab_vms]
}

resource "azurerm_network_interface_application_security_group_association" "vm1_frontend_asg" {
  network_interface_id          = data.azurerm_network_interface.vm1_nic.id
  application_security_group_id = azurerm_application_security_group.app_frontend_asg.id

  depends_on = [
    azurerm_resource_group_template_deployment.lab_vms
  ]
}