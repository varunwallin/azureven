terraform {
  required_version = "~> 1.3"
  backend "azurerm" {
    resource_group_name  = "rg-aue-prd-csmgt-tf"       # Replace with your resource group names
    storage_account_name = "saaeprdcsmgttf"            # Replace with your storage account name
    container_name       = "aue-az-lzvending-prd-tf-state"  # Replace with your container name
    key                  = "new-terraform.tfstate"         # Replace with your state file name
  }

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.7.0" # Ensure this matches your required version
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.management_subscription_id

}
