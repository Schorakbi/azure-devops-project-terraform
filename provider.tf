terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.27.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuredevops" {
  org_service_url       = var.azdo_org_url
  personal_access_token = var.azdo_pat
}
