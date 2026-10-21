output "firewall_private_ip" {
  description = "The private IP address of the Azure Firewall."
  value       = azurerm_firewall.app_vnet_firewall.ip_configuration[0].private_ip_address
}