## Backend (state) settings
variable "backend_resource_group_name" {
  description = "RG where the tfstate blob resides"
  type        = string
}
variable "backend_storage_account_name" {
  description = "Storage Account for tfstate"
  type        = string
}
variable "backend_container_name" {
  description = "Blob container for tfstate"
  type        = string
}
variable "backend_key" {
  description = "Path/key for the state file"
  type        = string
}

## Core infra inputs
variable "resource_group_name" {
  description = "Name of the main Azure Resource Group"
  type        = string
}
variable "location" {
  description = "Azure region"
  type        = string
  default     = "France Central"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
}
variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
}
variable "aks_node_count" {
  description = "Initial node count for AKS"
  type        = number
  default     = 3
}

## Self-hosted agent inputs
variable "vm_name" {
  description = "Name of the self-hosted agent VM"
  type        = string
  default     = "ado-agent-vm"
}

variable "agent_pool_name" {
  description = "Azure DevOps agent pool name"
  type        = string
  default     = "self-hosted-pool"
}

variable "azdo_org_url" {
  description = "Azure DevOps Organization URL"
  type        = string
}

variable "azdo_pat" {
  description = "Azure DevOps Personal Access Token"
  type        = string
  sensitive   = true
}

variable "agent_version" {
  description = "Version of the Azure Pipelines agent to install"
  type        = string
  default     = "4.254.0"
}
