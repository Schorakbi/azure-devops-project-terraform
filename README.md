# Azure DevOps Project Automation with Terraform

Automate the setup of your Azure DevOps environment—projects, repositories, pipelines, and more—using Terraform infrastructure as code.

---

## 🚀 Overview

Define and provision Azure DevOps projects consistently and repeatably using Terraform. Ideal for teams looking to:

- Enforce infrastructure as code
- Streamline project onboarding
- Maintain standardized environments

---

## 🛠️ Tech Stack

| Component  | Purpose |
|------------|---------|
| Terraform  | Define infrastructure as code |
| Azure DevOps Provider | Manage Azure DevOps resources via Terraform |
| Azure DevOps | Project hosting, repos, pipelines, service connections |

---

## ✅ Features

- Create or configure Azure DevOps projects automatically  
- Initialize Git repositories with predefined templates  
- Configure build and release pipelines (CI/CD)  
- Enforce consistency across environments through centralized definitions  

---

## 🎯 Pre-requisites

Make sure you have:

- [Terraform](https://www.terraform.io) (v0.13+ recommended)  
- An **Azure DevOps organization** with permissions to create projects/repos  
- A **Personal Access Token (PAT)** for Azure DevOps with sufficient access (code, pipelines, etc.)

---

## 🧩 Usage

```bash
# Clone the repository
git clone https://github.com/Schorakbi/azure-devops-project-terraform.git
cd azure-devops-project-terraform

# Optionally set environment variables
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/YOUR_ORG"
export AZDO_PERSONAL_ACCESS_TOKEN="YOUR_PAT"

# Initialize Terraform
terraform init

# Apply the configuration
terraform plan
terraform apply
```
