resource "azurerm_application_security_group" "app_frontend_asg" {
  name                = "app-frontend-asg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Lookup VM1 after the ARM deployment completes
data "azurerm_virtual_machine" "vm1" {
  name                = "vm1"
  resource_group_name = data.azurerm_resource_group.rg.name

  depends_on = [azurerm_resource_group_template_deployment.lab_vms]
}

# Associate VM1's primary NIC with the Application Security Group
resource "azurerm_network_interface_application_security_group_association" "vm1_frontend_asg" {
  network_interface_id          = data.azurerm_virtual_machine.vm1.network_interface_ids[0]
  application_security_group_id = azurerm_application_security_group.app_frontend_asg.id
}