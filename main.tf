# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    project = "online-boutique"
    env     = "prod"
  }
}

# 2. Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags = {
    project = "online-boutique"
    env     = "prod"
  }
}

# 3. AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # mandatory DNS prefix
  dns_prefix = var.aks_cluster_name

  default_node_pool {
    name       = "agentpool"
    node_count = var.aks_node_count
    vm_size    = "Standard_DS2_v2"
    max_pods   = 50
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    project = "online-boutique"
    env     = "prod"
  }
}

# 4. Grant AKS identity pull rights to ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Azure DevOps Agent VM

## 1) (Optional) Create the Agent Pool in Azure DevOps
resource "azuredevops_agent_pool" "pool" {
  name           = var.agent_pool_name
  auto_provision = false
  auto_update    = true
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "agent-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pubip" {
  name                = "${var.vm_name}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku                 = "Basic"            
  allocation_method   = "Dynamic"          
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
}

## 2) VM + Custom Script Extension to install & configure agent
resource "azurerm_linux_virtual_machine" "vm" {
  name                   = var.vm_name
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  size                   = "Standard_B2s"
  admin_username         = "azureuser"
  network_interface_ids  = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/Downloads/azure-agent_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

data "template_file" "agent_install" {
  template = file("${path.module}/scripts/install_agent.sh.tpl")

  vars = {
    AZDO_ORG_URL  = var.azdo_org_url
    AZDO_PAT      = var.azdo_pat
    AGENT_POOL    = var.agent_pool_name
    AGENT_NAME    = var.vm_name
    AGENT_VERSION = var.agent_version
  }
}

resource "azurerm_virtual_machine_extension" "install_agent" {
  name                 = "configure-ado-agent"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  # settings must be a JSON string
  settings = jsonencode({
    commandToExecute = data.template_file.agent_install.rendered
  })
}
