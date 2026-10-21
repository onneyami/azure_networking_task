data "http" "azure_deploy_template" {
  url = "https://raw.githubusercontent.com/MicrosoftLearning/Configure-secure-access-to-workloads-with-Azure-virtual-networking-services/main/Instructions/Labs/azuredeploy.json"

  request_headers = {
    Accept = "application/json"
  }
}

resource "azurerm_resource_group_template_deployment" "lab_vms" {
  name                = "lab-vm-deployment"
  resource_group_name = data.azurerm_resource_group.rg.name
  deployment_mode     = "Incremental"
  template_content    = data.http.azure_deploy_template.response_body

  # Ensure subnets exist before the ARM deployment starts
  depends_on = [
    azurerm_subnet.frontend,
    azurerm_subnet.backend
  ]
}