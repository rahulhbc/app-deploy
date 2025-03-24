variable "resource_group_name" {
  description = "Resource group name"
  default     = module.network.resource_group_name
}

variable "location" {
  description = "Azure region"
  default     = module.network.location
}