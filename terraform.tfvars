# Backend settings (you said you already have these)
backend_resource_group_name  = "terraform-rg"
backend_storage_account_name = "buylioinfra"
backend_container_name       = "tfstate"
backend_key                  = "terraform.tfstate"

# Core infra values
resource_group_name = "buylio-rg"
location            = "francecentral"
acr_name            = "buylioacr"
aks_cluster_name    = "buylio-aks"
aks_node_count      = 2
vm_name             = "azure-agent"

