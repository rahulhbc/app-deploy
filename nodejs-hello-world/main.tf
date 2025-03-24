# Fetch existing Terraform state from 3TierIaC
data "terraform_remote_state" "networking" {
  backend = "azurerm"

  config = {
    resource_group_name  = "iac-secure-rg"
    storage_account_name = "app-deploy"
    container_name       = "tfstate"
    key                  = "3TierIaC.tfstate"
  }
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
    public_key = var.ssh_public_key
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
