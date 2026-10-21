
# Azure Hub-and-Spoke VNet Topology with Terraform

This project deploys a hub-and-spoke virtual network topology in Azure using Terraform. It provisions an existing resource group reference, two virtual networks with dedicated subnets, and establishes bidirectional VNet peering between them.

---

## Architecture Overview

```text
               +--------------------------------------+
               |        Resource Group: rg-andrei     |
               +--------------------------------------+
                                  |
         +------------------------+------------------------+
         |                                                 |
         v                                                 v
+-----------------------+                         +-----------------------+
|       hub-vnet        |<=======================>|       app-vnet        |
|     10.0.0.0/16       |     Bidirectional       |     10.1.0.0/16       |
+-----------------------+        Peering          +-----------------------+
|  AzureFirewallSubnet  |                         |  frontend Subnet      |
|     10.0.0.0/26       |                         |     10.1.0.0/24       |
+-----------------------+                         +-----------------------+
                                                  |  backend Subnet       |
                                                  |     10.1.1.0/24       |
                                                  +-----------------------+

```

### Components

* **Hub Network (`hub-vnet`)**:
* Address Space: `10.0.0.0/16`
* Subnet: `AzureFirewallSubnet` (`10.0.0.0/26`) for network security appliances or Azure Firewall.
* **Spoke Network (`app-vnet`)**:
* Address Space: `10.1.0.0/16`
* Subnets:
* `frontend` (`10.1.0.0/24`)
* `backend` (`10.1.1.0/24`)
* **VNet Peering**:
* `app-vnet-to-hub` (Spoke to Hub)
* `hub-to-app-vnet` (Hub to Spoke)

---

## Repository Structure

```text
.
├── README.md           # Project documentation
├── providers.tf        # Terraform configuration and Azure provider setup
├── variables.tf        # Input variable definitions (resource group name)
├── main.tf             # Data source referencing existing resource group rg-andrei
├── vnet_hub.tf         # Hub VNet and AzureFirewallSubnet definition
├── vnet_app.tf         # App VNet, frontend, and backend subnets definition
├── peering.tf          # Bidirectional VNet peering configuration
└── outputs.tf          # Exported VNet IDs

```

---

## Prerequisites

1. **Terraform**: CLI version `>= 1.3.0` installed.
2. **Azure CLI**: Version `2.30.0` or higher installed.
3. **Azure Subscription**: Active subscription with `Contributor` role access.
4. **Target Resource Group**: An existing Azure Resource Group named `rg-andrei`.

---

## Deployment Instructions

### 1. Authenticate to Azure

Log in to your Azure account and select the appropriate target subscription:

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"

```

### 2. Initialize Terraform

Download the `azurerm` provider plugin and initialize the working directory:

```bash
terraform init

```

### 3. Review Execution Plan

Generate an execution plan to verify resources to be created:

```bash
terraform plan

```

### 4. Apply Configuration

Deploy the virtual networks, subnets, and peering connections:

```bash
terraform apply

```

Confirm the action by typing `yes` when prompted.

---

## Verification

Once applied, verify that the VNet peering status is **Connected**:

```bash
az network vnet peering list \
  --resource-group rg-andrei \
  --vnet-name app-vnet \
  --output table

```

Output should display `Connected` under the `PeeringState` column for both directions.

---

## Teardown

To remove all provisioned network resources without deleting the underlying `rg-andrei` resource group:

```bash
terraform destroy

```
