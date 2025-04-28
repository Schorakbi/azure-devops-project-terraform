output "resource_group" {
  value       = azurerm_resource_group.rg.name
  description = "Name of the resource group"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "ACR login server (for docker login)"
}

output "kube_config_raw" {
  description = "Raw kubeconfig for AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "agent_vm_public_ip" {
  description = "Public IP address of the self-hosted agent VM"
  value       = azurerm_public_ip.pubip.ip_address
}

output "agent_pool_id" {
  description = "Azure DevOps Agent Pool ID"
  value       = azuredevops_agent_pool.pool.id
}
