# 1. Lookup the frontend subnet in app-vnet
data "azurerm_subnet" "frontend" {
  name                 = "frontend"
  virtual_network_name = data.azurerm_virtual_network.app_vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  depends_on           = [azurerm_resource_group_template_deployment.lab_vms]
}

# 2. Route Table with default 0.0.0.0/0 route pointing to the Azure Firewall
resource "azurerm_route_table" "app_vnet_firewall_rt" {
  name                          = "app-vnet-firewall-rt"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "outbound-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.app_vnet_firewall.ip_configuration[0].private_ip_address
  }
}

# 3. Associate Route Table to the frontend subnet
resource "azurerm_subnet_route_table_association" "frontend_rt_assoc" {
  subnet_id      = data.azurerm_subnet.frontend.id
  route_table_id = azurerm_route_table.app_vnet_firewall_rt.id
}

# 4. Associate Route Table to the backend subnet
resource "azurerm_subnet_route_table_association" "backend_rt_assoc" {
  subnet_id      = data.azurerm_subnet.backend.id
  route_table_id = azurerm_route_table.app_vnet_firewall_rt.id
}