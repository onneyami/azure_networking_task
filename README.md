
# Azure Secure Workload Networking with Terraform

This repository provisions a secure enterprise networking architecture in Azure using Terraform, covering all 5 modules of the Microsoft Guided Project: *Configure secure access to workloads with Azure virtual networking services*.

---

## Architecture Components

* **Virtual Networks & Peering (`peering.tf`, `vnet_hub.tf`, `vnet_app.tf`)**:
  * Hub VNet (`vnet-hub`: `10.0.0.0/16`) and Workload Spoke VNet (`app-vnet`: `10.1.0.0/16`).
  * Bidirectional VNet Peering links (`app-vnet-to-hub-vnet` and `hub-vnet-to-app-vnet`).
* **Workload Infrastructure (`vms.tf`)**:
  * Automated incremental ARM deployment provisioning `vm1` in `frontend` (`10.1.0.0/24`) and `vm2` in `backend` (`10.1.1.0/24`).
* **Network & Application Security (`asg.tf`, `nsg.tf`)**:
  * Application Security Group `app-frontend-asg` mapped to `vm1-nic`.
  * Network Security Group `app-vnet-nsg` attached to the `backend` subnet, enforcing rule `AllowSSH` (Priority 100) specifically for traffic originating from `app-frontend-asg`.
* **Centralized Firewall Protection (`firewall.tf`)**:
  * Azure Firewall Standard (`app-vnet-firewall`) deployed in `AzureFirewallSubnet` (`10.1.63.0/26`) with static public IP `fwpip`.
  * Firewall Policy (`fw-policy`) with:
    * **Application Rules**: Outbound HTTPS (443) access to `dev.azure.com` and `azure.microsoft.com`.
    * **Network Rules**: Outbound DNS queries (port 53 UDP) to `1.1.1.1` and `1.0.0.1`.
* **Custom Route Tables (`routing.tf`)**:
  * Route Table `app-vnet-firewall-rt` associated with both `frontend` and `backend` subnets.
  * Overrides default system routing with route `outbound-firewall` directing all `0.0.0.0/0` outbound traffic to the firewall's private IP (`10.1.63.4`).
* **Private DNS Resolution (`dns.tf`)**:
  * Private DNS Zone `private.contoso.com` linked to `app-vnet` with dynamic VM auto-registration.
  * Custom `A` record pointing `backend.private.contoso.com` to `10.1.1.5`.

---

## File Structure

```text
.
├── README.md           # Project architecture and instructions
├── providers.tf        # Terraform & provider constraints (azurerm, http)
├── variables.tf        # Input variable definitions (resource group name)
├── main.tf             # Data reference to existing resource group rg-andrei
├── vnet_hub.tf         # vnet-hub virtual network definition
├── vnet_app.tf         # Data references for app-vnet and its subnets
├── vms.tf              # Template deployment for lab VMs (vm1, vm2)
├── peering.tf          # Bidirectional VNet peering configuration
├── asg.tf              # ASG creation and VM1 NIC association
├── nsg.tf              # NSG creation, AllowSSH rule, and backend association
├── firewall.tf         # Azure Firewall, public IP, policy, and rule collections
├── routing.tf          # Route table, 0.0.0.0/0 route, and subnet associations
├── dns.tf              # Private DNS zone, VNet link, and A records
└── outputs.tf          # Firewall private IP output
```

---

## Deployment & Teardown

### Deploy Everything

```bash
terraform init
terraform apply -auto-approve

```

### Clean Up Resources

To remove all provisioned network and security resources while preserving the base resource group `rg-andrei`:

```bash
terraform destroy -auto-approve
```
