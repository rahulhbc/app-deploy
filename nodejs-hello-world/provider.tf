terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}

  subscription_id = "7c63e1b6-0a9a-487e-b657-e58721d3e957"
  tenant_id       = "f862763a-bd62-4c7e-bc68-befeaed1b9fb"
}