variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

variable "resource_group_name" {
  description = "Resource group name"
  default     = "iac-secure-rg"
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}