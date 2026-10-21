# 1. Private DNS Zone
resource "azurerm_private_dns_zone" "private_contoso" {
  name                = "private.contoso.com"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# 2. Virtual Network Link to app-vnet with Auto-Registration
resource "azurerm_private_dns_zone_virtual_network_link" "app_vnet_link" {
  name                  = "app-vnet-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_contoso.name
  virtual_network_id    = data.azurerm_virtual_network.app_vnet.id
  registration_enabled  = true
}

# 3. Static A Record for Backend
resource "azurerm_private_dns_a_record" "backend_record" {
  name                = "backend"
  zone_name           = azurerm_private_dns_zone.private_contoso.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 3600 # 1 hour (Azure Portal default unit is Hours)
  records             = ["10.1.1.5"]
}