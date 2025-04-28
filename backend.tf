terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-rg"
    storage_account_name  = "buylioinfra"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}