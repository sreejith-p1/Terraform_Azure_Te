terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "example" {
  name                     = "learnstoragefree123"  # must be globally unique
  resource_group_name      = "learn-f4bf4cb5-7c2e-42cc-b91b-04dfeae50ca5"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "practice"
  }
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "tf-practice-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "learn-f4bf4cb5-7c2e-42cc-b91b-04dfeae50ca5"
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "tf-practice-subnet"
  resource_group_name  = "learn-f4bf4cb5-7c2e-42cc-b91b-04dfeae50ca5"
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example_nic" {
  name                = "tf-practice-nic"
  location            = "East US"
  resource_group_name = "learn-f4bf4cb5-7c2e-42cc-b91b-04dfeae50ca5"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "tf-practice-vm"
  resource_group_name = "learn-f4bf4cb5-7c2e-42cc-b91b-04dfeae50ca5"
  location            = "East US"

  size                = "Standard_B1s"  # Cheapest free-tier eligible size
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.example_nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/opscode/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
