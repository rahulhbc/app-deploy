terraform {
  backend "azurerm" {
    resource_group_name  = "RG-RBAC"
    storage_account_name = "storagelab001"
    container_name       = "3tier-app"
    key                  = "app-deploy.tfstate"
    subscription_id      = "7c63e1b6-0a9a-487e-b657-e58721d3e957"
  }
}