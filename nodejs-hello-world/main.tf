# Fetch existing Terraform state from 3TierIaC
data "terraform_remote_state" "networking" {
  backend = "azurerm"

  config = {
    resource_group_name  = "iac-secure-rg"
    storage_account_name = "yourstorageaccount"
    container_name       = "tfstate"
    key                  = "3TierIaC.tfstate"
  }
}

# SSH Key Variables
variable "ssh_public_key" {
  description = "SSH public key for VM login"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private key for VM login"
  type        = string
}

# Use the outputs from 3TierIaC instead of defining networking again
resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                = "frontend-vm"
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name
  location            = data.terraform_remote_state.networking.outputs.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"


  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_profile_linux_config {
    disable_password_authentication = true
  }

  network_interface_ids = [data.terraform_remote_state.networking.outputs.frontend_nic_id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 8
    name                 = "frontend-os-disk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  # Output IP
  output "public_ip" {
    description = "Public IP address of the VM"
    value       = data.terraform_remote_state.network.outputs.public_ip
  }

  # Output VM Details
  output "vm_name" {
    description = "Name of the virtual machine"
    value       = azurerm_linux_virtual_machine.frontend_vm.name
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io -y",
      "sudo systemctl start docker",
      "sudo docker run -d -p 3000:80 rahulhbc/nodejs-hello-world:v1"
    ]

    connection {
      type        = "ssh"
      host        = data.terraform_remote_state.networking.outputs.frontend_public_ip
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
