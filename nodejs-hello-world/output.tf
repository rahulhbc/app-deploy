output "public_ip" {
  description = "Public IP address of the VM"
  value       = data.terraform_remote_state.network.outputs.public_ip
}

output "resource_group_name" {
  description = "The name of the existing resource group"
  value       = data.terraform_remote_state.network.outputs.resource_group_name
}

output "location" {
  description = "The location of the existing resource group"
  value       = data.terraform_remote_state.network.outputs.location
}

output "vnet_name" {
  description = "The name of the existing Virtual Network"
  value       = data.terraform_remote_state.network.outputs.vnet_name
}

output "nsg_name" {
  description = "The name of the existing Network Security Group"
  value       = data.terraform_remote_state.network.outputs.nsg_name
}

output "frontend_nic" {
  description = "Network Interface ID from Network State"
  value       = data.terraform_remote_state.network.outputs.frontend_nic
}
