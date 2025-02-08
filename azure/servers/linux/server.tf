data "azurerm_subnet" "private_b" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group
}

# Create network interface
resource "azurerm_network_interface" "demo_nic" {
  name                  = "${var.server_name}-NIC"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group

  ip_configuration {
    name                          = "demo_nic_configuration"
    subnet_id                     = data.azurerm_subnet.private_b.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "demo_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "demo_vm" {
  name                  = var.server_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.demo_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = var.server_name
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.demo_ssh.public_key_openssh
  }

  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  # }

  tags = {
      Created     = "27 Jun 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Brian Gaber"
      Application = "SRETools"
      Portfolio   = "Other"
    }
}

output "subnet_id" {
  value = data.azurerm_subnet.private_b.id
}

output "instance_id" {
  value = azurerm_linux_virtual_machine.demo_vm.id
}

output "private_ip_address" {
  value = azurerm_linux_virtual_machine.demo_vm.private_ip_address
}

output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.demo_vm.virtual_machine_id
}