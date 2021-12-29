# Module 04 - Terraform deployment at scale

[< Previous Module](../modules/module03.md) - **[Home](../README.md)**

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).

## :loudspeaker: Introduction

In this module, you will learn about deploying terraform deployment at scale.

## :dart: Objectives

* Create generic terraform module for azure services you are planning to deploy.
* Create terraform deployment templates.
* Create environment specific variables files for azure resource deployment.
* Create environment agnostic pipeline that make use of pipelines and variables to deploy services in multiple environments.
* Deploy Storage account, key vault and data factory contained in a resource group.

##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [Terraform Code Review for Data Factory](#1-terraform-code-review-for-data-factory) | Azure Administrator |
| 2 | [Terraform deployment template pipeline review](#2-terraform-deployment-template-pipeline-review) | Azure Administrator |
| 3 | [Deployment variables files review](#3-deployment-variables-files-review) | Azure Administrator |
| 4 | [Deployment pipeline review](#4-deployment-pipeline-review) | Azure Administrator |

## 1. Terraform Code Review for Data Factory

Terraform code for each azure resource consists of atleast four files:
 - main.tf: File containing providers information, local variables and actual code for resource deployment

```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.74.0"
    }
  }
}

provider "azurerm" {
  features {    
  }
}

locals {
create_data_factory_git_vsts_set   = var.data_factory_vsts_account_name == "" ? toset([]) : toset(["_"])
default_tags = {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_data_factory" "adf" {
  count               = var.index
  name                = format("adf-%s-%s-%s-%s-%03d", var.team_name, var.client_name,var.environment,var.location_accronym[var.location],"${count.index + var.counter}")
  location            = var.location
  resource_group_name = var.resource_group_name
  public_network_enabled = var.public_network_enabled
  tags                = merge(local.default_tags, var.extra_tags)
  managed_virtual_network_enabled = var.managed_virtual_network_enabled 

  identity {
    type = "SystemAssigned"
  }

  dynamic "vsts_configuration" {
    for_each          = local.create_data_factory_git_vsts_set
    content {
      account_name    = var.data_factory_vsts_account_name
      branch_name     = var.data_factory_vsts_branch_name
      project_name    = var.data_factory_vsts_project_name
      repository_name = var.data_factory_vsts_repository_name
      root_folder     = var.data_factory_vsts_root_folder
      tenant_id       = var.data_factory_vsts_tenant_id
    }
  }
}

```
 
 - backend.tf: File containing the azurerm backend information for state file storage.

```
terraform {
 backend "azurerm" {

 }
}
```

 - variables.tf: File to define the variables used in the terraform code

```
variable "location_accronym"{
  type        = map
  default     = {
    "canadacentral" = "cacn"
    "canadaeast"    = "caea"
  }
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "team_name" {
  default = "devops"
  description = "team name - usually refers to line of business "
   validation {
    condition = length(var.team_name) < 5
    error_message = "Shouldn't be more than 4 characters"
  }
}

variable "index" {
  default = 1  
  description = "Resource index - helpful when creating multiple resources with same name at once."
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}

variable "public_network_enabled" {
  type        = bool
  default     = true
  description = "Nom principal de la ressource sans les prefixes ni sufixes"
}

variable "managed_virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Enabling Vnet in ADF is required to create a vnet for the managed intergration runtime"
}

variable "client_name" {
  type        = string
  description = "client name"
  default     = "bcmp"
}

variable "location" {
  type        = string
  default     = "canadacentral"
  description = "Azure Region location to use for deploying resources"
  validation {
    condition = var.location == "canadacentral" || var.location == "canadaeast"
    error_message = "Invalida Azure Region provided."  
  }
}

variable "environment" {
  type        = string  
  description = "Environment Abbreviation"
  default     = "de"
  validation {
    condition = var.environment == "de" || var.environment == "pp" || var.environment == "pr"
    error_message = "Environment Abbreviation"
  }
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group to use for deploying this resource"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags, other than the common tags"
}

variable "data_factory_vsts_account_name" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Organization Name"
}

variable "data_factory_vsts_branch_name" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Collaboration Branch Name"
}

variable "data_factory_vsts_project_name" {
  type        = string
  default     = ""
  description = "Data Factory Git - Project Name"
}

variable "data_factory_vsts_repository_name" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Repository Name"
}

variable "data_factory_vsts_root_folder" {
  type        = string
  default     = "/"
  description = "(Optional)Data Factory Git - Root folder in the repository. Defaults to /"
}

variable "data_factory_vsts_tenant_id" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Tenant ID"
}

```

  - outputs.tf: File containing the resource attributes to print after the code deployment.

```
output "data_factory_name" {
  value       = azurerm_data_factory.adf[*].name
  description = "Name of Azure data factory."
}

output "data_factory_id" {
  value       = azurerm_data_factory.adf[*].id
  description = "Resource ID for data factory"
}

```
  - Go through the other three folder (rg, kv and adls) in tfcode folders to familiarize yourself with the terraform code for these modules.


## 2. Terraform deployment template pipeline review





## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: This pipeline generates the terraform plan and then applies in a single step however, in an ideal scenario, we would like to review the plan and wait for explicit approval before this plan is applied. Repurpose this pipeline to implement the desired solution. (Hint - Make use of pipeline environments)

## :tada: Summary

This module provided an overview of how to do terraform deployment at scale.
