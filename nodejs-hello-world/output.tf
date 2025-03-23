output "resource_group_name" {
  description = "The name of the existing resource group"
  value       = data.azurerm_resource_group.rg.name
}

output "location" {
  description = "The location of the existing resource group"
  value       = data.azurerm_resource_group.rg.location
}

output "vnet_name" {
  description = "The name of the existing Virtual Network"
  value       = data.azurerm_virtual_network.vnet.name
}

output "nsg_name" {
  description = "The name of the existing Network Security Group"
  value       = data.azurerm_network_security_group.frontend_nsg.name
}