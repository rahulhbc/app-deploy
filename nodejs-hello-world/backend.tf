terraform {
  backend "azurerm" {
    resource_group_name  = "RG-RBAC"
    storage_account_name = "storagelab001"
    container_name       = "3tier"
    key                  = "terraform.tfstate"
  }
}
