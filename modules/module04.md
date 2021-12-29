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
isUsingSharedIR = var.isUsingSharedIR == true ? toset(["_"]) : toset([])
index = var.enableShir ? var.index : 0
mngdtir = var.enableMngdtir ? 1 : 0
adfmpep = var.enableAdfmpep ? length(var.adfmpep_name) * var.index : 0
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
variable "team_name" {
  default = "faa"
  description = "Nom "
   validation {
    condition = length(var.team_name) < 5
    error_message = "Le nom du team doit contenir au plus 4 caractères."
  }
}

variable "module_name" {
  type        = string
  description = "Name of module for which private end point is being created."
  default     = ""
}

variable "isUsingSharedIR" {
  type        = bool
  description = "Is thie ADF going to use Shared Self hosted integration runtime"
  default     = true
}


variable "isConnectionToSqlDatabaseNeeded" {
  type        = bool
  description = "Flag to determine if you need to create the SqlDatabaseConnection while creating ADF"
  default     = false
}

variable "enableShir" {
  type        = bool
  description = "Is thie ADF going to use Shared Self hosted integration runtime"
  default     = false
}

variable "enableMngdtir" {
  type        = bool
  description = "Flag to determine whether or not to enable Managed VNET Integration runtime"
  default     = false
}

variable "enableAdfmpep" {
  type        = bool
  description = "Flag to determine whether or not to enable ADF managed private endpoint"
  default     = false
}

variable "masterDataFactoryName" {
  type        = string
  description = "Name of data factory which hosted sharable self hosted integration runtime. Will only be used if isUsingSharedIR is set to true"
  default     = ""
}

variable "masterDataFactoryRGName" {
  type        = string
  description = "Name of resource group of data factory which hosted sharable self hosted integration runtime. Will only be used if isUsingSharedIR is set to true"
  default     = ""
}

variable "mastershir" {
  type        = string
  description = "Name of master self hosted integration runtime"
  default     = ""
}

variable "shir" {
  type        = string
  description = "Name of self hosted integration runtime"
  default     = ""
}

variable "mngdir" {
  type        = string
  description = "Name of managed integration runtime"
  default     = ""
}

variable "nodesize" {
  type        = string
  description = "Node size for managed integration runtime"
  default     = ""
}

variable "location_accronym"{
  type        = map
  default     = {
    "canadacentral" = "cacn"
    "canadaeast"    = "caea"
  }
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "index" {
  default = 1  
  description = "Quand on a besoin de creer une sequence de rg on utilise ce variable pour ajouter la sequence à la fin"
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}

variable "public_network_enabled" {
  type        = bool
  default     = false
  description = "Nom principal de la ressource sans les prefixes ni sufixes"
}

variable "managed_virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Enabling Vnet in ADF is required to create a vnet for the managed intergration runtime"
}

variable "virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Enabling Vnet in Integration Runtime"
}

variable "client_name" {
  type        = string
  default     = "faa"
  description = "Nom principal de la ressource sans les prefixes ni sufixes"
}

variable "location" {
  type        = string
  default     = "canadacentral"
  description = "La region ou le resource groupe doit etre cree"
  validation {
    condition = var.location == "canadacentral" || var.location == "canadaeast"
    error_message = "Les seules locations valides sont: canadacentral et canadaeast."  
  }
}

variable "environment" {
  type        = string  
  default     = "de"
  description = "L'environnment"
  validation {
    condition = var.environment == "de" || var.environment == "pp" || var.environment == "pr"
    error_message = "L'environnement doivent etre choisi parmi les options : de, pp, pr."
  }
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Nom du groupe de ressources dans lequel les ressources doivent être créées"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "Id du subnet dans lequel le private endpoint doit être créé"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Les TAGS que doit faire partie des tags du resource"
}

variable "data_factory_vsts_account_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom du compte pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_branch_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom de la branche le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_project_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom du projet pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_repository_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom du repo pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_root_folder" {
  type        = string
  default     = ""
  description = "Optionnel Fichier root pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_tenant_id" {
  type        = string
  default     = ""
  description = "Optionnel ID du tenant pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "log_analytics_workspace_log"{
  type        = string
  description = "Log Analytics Workspace logs"
}

variable "log_analytics_workspace_metric"{
  type        = string
  description = "Log Analytics Workspace for metric"
}

variable "log_analytics_workspace_log_rg"{
  type        = string
  description = "Resource Group for Log Analytics workspace for storing Log "
}

variable "log_analytics_workspace_metric_rg"{
  type        = string
  description = "Resource Group for Log Analytics workspace for storing metrics "
}

variable "adf_log_setting_name"{
  type        = string
  description = "Name of diagnostic setting for logs on keyvault"
  default = "log2LogAnalytics"
}

variable "adf_metric_setting_name"{
  type        = string
  description = "Name of diagnostic setting for metrics on keyvault"
  default = "metric2LogAnalytics"
}
variable "sec_subscription_id"{
  type        = string
  description = "Service partagee subscription id"
  default     = ""
}
variable "subnet_pep_id"{
  type        = string
  description = "Azure Subnet ID "
}

variable "sqldb_linkedservice_name"{
  type        = string
  description = "Linked service name"
  default     = ""
}

variable "connection_string"{
  type        = string
  description = "SQL database connnection string"
  default     = ""
}

variable "adfmpep_name"{
  type        = list(string)
  description = "ADF managed private endpoint names"
  default     = [""]
}

variable "resource_id"{
  type        = list(string)
  description = "List of resource ID of Azure services connecting to the private endpoint"
  default     = [""]
}

variable "subresource_name"{
  type        = list(string)
  description = "List of subresource name of which is connecting via ADF managed private endpoint"
  default     = [""]
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



## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: This pipeline generates the terraform plan and then applies in a single step however, in an ideal scenario, we would like to review the plan and wait for explicit approval before this plan is applied. Repurpose this pipeline to implement the desired solution. (Hint - Make use of pipeline environments)

## :tada: Summary

This module provided an overview of how to do terraform deployment at scale.
