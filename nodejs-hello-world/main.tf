data "azurerm_resource_group" "existing_rg" {
  name = "iac-secure-rg" # Ensure this matches the actual resource group name
}

data "azurerm_virtual_network" "vnet" {
  name                = "iac-vnet"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

data "azurerm_network_security_group" "frontend_nsg" {
  name                = "frontend-nsg"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

module "tier3_app" {
  source              = "github.com/rahulhbc/3TierIaC.git//multi_tier_arch"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
}

resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                = "frontend-vm"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  network_interface_ids = [module.tier3_app.frontend_nic_id]

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
      host        = module.tier3_app.frontend_public_ip
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
