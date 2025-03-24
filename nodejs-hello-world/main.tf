# Fetch existing Terraform state from 3TierIaC
data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = "RG-RBAC"
    storage_account_name = "storagelab001"
    container_name       = "3tier"
    key                  = "terraform.tfstate"
  }
}

# Use the outputs from 3TierIaC instead of defining network again
resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                = "frontend-vm"
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"


  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  network_interface_ids = [data.terraform_remote_state.network.outputs.frontend_nic_id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
    name                 = "frontend-os-disk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19_04-gen2"
    version   = "19.04.202001220"
  }
}

#Resource for custom data
resource "azurerm_virtual_machine_extension" "custom_script" {
  name                 = "vmCustomScript"
  virtual_machine_id   = azurerm_linux_virtual_machine.frontend_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/rahulhbc/app-deploy/refs/heads/feat/test_branch1/nodejs-hello-world/userdata.sh"],
        "commandToExecute": "bash userdata.sh"
    }
  SETTINGS
}
