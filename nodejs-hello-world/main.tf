module "tier3_app" {
  source = "github.com/rahulhbc/3TierIaC.git//multi_tier_arch"
}

resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                  = "frontend-vm"
  resource_group_name   = module.3tier_app.resource_group_name
  location              = module.3tier_app.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"

  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  network_interface_ids = [module.3tier_app.frontend_nic_id]

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
      "sudo docker run -d -p 80:3000 rahulhbc/nodejs-hello-world:v1"
    ]

    connection {
      type        = "ssh"
      host        = module.3tier_app.frontend_public_ip
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
