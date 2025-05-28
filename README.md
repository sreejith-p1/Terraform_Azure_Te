# Terraform_Azure_Te


Storage Account: Creates an Azure Storage Account for storing data (name must be globally unique).

Virtual Network (VNet): Defines a virtual network with a CIDR block of 10.0.0.0/16.

Subnet: Creates a subnet inside the VNet with address range 10.0.1.0/24.

Network Interface (NIC): Creates a network interface attached to the subnet for VM networking.

Linux Virtual Machine: Deploys an Ubuntu 18.04 Linux VM connected to the NIC, with SSH access using a public key.
