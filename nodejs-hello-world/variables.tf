variable "client_id" {
  description = "Azure Client ID"
}

variable "client_secret" {
  description = "Azure Client Secret"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
}
variable "resource_group_name" {
  description = "Resource group name"
  default     = "iac-secure-rg"
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "ssh_public_key" {
  description = "SSH public key for VM login"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private key for VM login"
  type        = string
}