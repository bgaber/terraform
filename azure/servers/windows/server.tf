data "azurerm_subnet" "private_b" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "windows_svr_nsg" {
  name                = "${var.server_name}-NSG"
  location            = var.resource_group_location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Created     = "27 Jun 2024"
    Creator     = "Brian Gaber using Terraform"
    Owner       = "Matthew Riding"
    Application = "AIOps"
    Change      = "CHG215101"
    Portfolio   = "AIOps"
  }
}

# Create network interface
resource "azurerm_network_interface" "windows_svr_nic" {
  name                  = "${var.server_name}-NIC"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group

  ip_configuration {
    name                          = "windows_svr_nic_configuration"
    subnet_id                     = data.azurerm_subnet.private_b.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Created     = "27 Jun 2024"
    Creator     = "Brian Gaber using Terraform"
    Owner       = "Matthew Riding"
    Application = "AIOps"
    Change      = "CHG215101"
    Portfolio   = "AIOps"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.windows_svr_nic.id
  network_security_group_id = azurerm_network_security_group.windows_svr_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "windows_svr_storage_account" {
  name                     = join("", ["diag", lower(var.server_name)])
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Created     = "27 Jun 2024"
    Creator     = "Brian Gaber using Terraform"
    Owner       = "Matthew Riding"
    Application = "AIOps"
    Change      = "CHG215101"
    Portfolio   = "AIOps"
  }
}

# Create Windows virtual machine
resource "azurerm_windows_virtual_machine" "windows_svr_vm" {
  name                  = var.server_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.windows_svr_nic.id]
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  admin_password        = "P@$$w0rd1234!"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.windows_svr_storage_account.primary_blob_endpoint
  }

  tags = {
    Created     = "27 Jun 2024"
    Creator     = "Brian Gaber using Terraform"
    Owner       = "Matthew Riding"
    Application = "AIOps"
    Change      = "CHG215101"
    Portfolio   = "AIOps"
  }
}

output "subnet_id" {
  value = data.azurerm_subnet.private_b.id
}

output "security_group_id" {
  value = azurerm_network_security_group.windows_svr_nsg.id
}

output "nic_id" {
  value = azurerm_network_interface.windows_svr_nic.id
}

output "instance_id" {
  value = azurerm_windows_virtual_machine.windows_svr_vm.id
}

output "private_ip_address" {
  value = azurerm_windows_virtual_machine.windows_svr_vm.private_ip_address
}

output "virtual_machine_id" {
  value = azurerm_windows_virtual_machine.windows_svr_vm.virtual_machine_id
}