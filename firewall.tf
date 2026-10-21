# 1. Dedicated Subnet for Azure Firewall in app-vnet
resource "azurerm_subnet" "app_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.app_vnet.name
  address_prefixes     = ["10.1.63.0/26"]
}

# 2. Standard Static Public IP for the Firewall
resource "azurerm_public_ip" "fwpip" {
  name                = "fwpip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 3. Azure Firewall Policy (Standard Tier)
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "fw-policy"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard"
}

# 4. Application Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "app_rules" {
  name               = "DefaultApplicationRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 300

  application_rule_collection {
    name     = "app-vnet-fw-rule-collection"
    priority = 200
    action   = "Allow"

    rule {
      name             = "AllowAzurePipelines"
      source_addresses = ["10.1.0.0/23"]

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "dev.azure.com",
        "azure.microsoft.com"
      ]
    }
  }
}

# 5. Network Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 200

  network_rule_collection {
    name     = "app-vnet-fw-nrc-dns"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "AllowDns"
      protocols             = ["UDP"]
      source_addresses      = ["10.1.0.0/23"]
      destination_ports     = ["53"]
      destination_addresses = ["1.1.1.1", "1.0.0.1"]
    }
  }
}

# 6. Azure Firewall
resource "azurerm_firewall" "app_vnet_firewall" {
  name                = "app-vnet-firewall"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id

  ip_configuration {
    name                 = "fwpip"
    subnet_id            = azurerm_subnet.app_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.fwpip.id
  }

  depends_on = [
    azurerm_firewall_policy_rule_collection_group.app_rules,
    azurerm_firewall_policy_rule_collection_group.network_rules
  ]
}