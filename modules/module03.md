# Module 03 - Terraform Crash Course

[< Previous Module](../modules/module02.md) - **[Home](../README.md)** - [Next Module >](../modules/module04.md)

## :thinking: Prerequisites
* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Azure CLI to enable login to Azure subscription and deploy resources.

## :loudspeaker: Introduction

In this module, you'll learn how to get started with Terraform very quickly in this article. Main goal here is to focus on a few basic concepts of Terraform so you can install and deploy your very first Terraform script today. This is going to be straight to the point and focused on using Terraform on Windows with Azure. I will demonstrate this in the simplest of ways so that you can grasp the concepts and see this work end-to-end. Before you start, you should also create an empty folder for the workspace for this crash course.

## :dart: Objectives

* Create first terraform script
* Deploy the terraform script to azure subscription

##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [Terraform Installation](#1-terraform-installation) | Local Administrator |
| 2 | [Azure CLI](#2-azure-cli) | Local Administrator |
| 3 | [Terraform Provider](#3-terraform-provider) | NA |
| 4 | [HashiCorp Language (HCL)](#4-hashicorp-language) | NA |
| 5 | [Terraform Commands](#5-terraform-commands) | NA |


## 1. Terraform Installation
I typically create a Downloads folder and add that to my System Environment path variables. This makes it easy for me to maintain static binary tools that I download like Terraform.

https://www.terraform.io/downloads.html

### 1a. Steps
- Create Downloads\terraform folder.
- Export to Environment Variable for Paths
- [Download](https://www.terraform.io/downloads.html) and extract 64 bit Terraform binary to terraform folder.

![image](https://user-images.githubusercontent.com/19226157/147651478-d9f7c7fa-d512-4657-835a-88e4a38f2c84.png)


### 1b. Verify Installation
To verify installation you should be able to run a basic terraform command to see if Windows recognizes the bin path and finds Terraform.

```
terraform version
```

![image](https://user-images.githubusercontent.com/19226157/147651594-4f023319-883f-4d9b-b297-4eee21c8a04a.png)

 
## 2. Azure CLI

You will need to have Azure CLI installed and working. Before you can run any of the Terraform commands below you will need to log in and set your subscription to the one you will want to use. Use the commands below to accomplish this task.

### 2a. Logging In
You’ll need to be authenticated against Azure to do any of this so make sure you run this command below.

az login --use-device-code

### 2b. List Accounts
az account list -o table

![image](https://user-images.githubusercontent.com/19226157/147651732-5db5d460-1369-45af-8965-ca0cfc9addc7.png)

### 2c. Set the Account Context
To tell Azure CLI and Terraform which Tenant and Subscription this will run against use the command below. Replace {GUID} with your Subscription ID from the output above.

az account set --subscription {GUID}

 
## 3. Terraform Providers
Providers are simple to understand if you start with this thought, they are the gateway in which Terraform talks to a service to create infrastructure. For example, the azurerm provider allows Terraform to create infrastructure within Azure. The provider provides general settings and a library for creating Terraform scripts.

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

### 3a. Create a providers.tf file
This is the bare minimum code that is needed in the providers.tf file to tell Terraform which version of azurerm it should use to communicate with Azure.

```
providers.tf
terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>2.59.0"
        }
    }
}

provider "azurerm" {
    features {}
}
 
```
You can also add this code to main.tf file as well if you don't wishes to create a separate file.

## 4. HashiCorp Language (HCL)

HashiCorp Language (HCL) is similar to YAML and is a declarative style with blocks, identifiers, data sources, output, variables, and can provide functionality for mapping values into the blocks.

https://www.terraform.io/docs/language/syntax/configuration.html

### 4a. Create a main.tf file

The main.tf file will be our main Terraform file for creating an Resource Group. 

You can reference the documentation in the Terraform Registry for azurerm.

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

```
locals {
enable_locks = var.enable_locks ? var.index : 0
default_tags = {}
}

resource "azurerm_resource_group" "rg" {
  count    = var.index
  location = var.location
  name     = format("rg-%s-%s-%s-%s-%03d", var.team_name, var.client_name,var.environment,var.location_accronym[var.location],"${count.index + var.counter}")
  tags     = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_management_lock" "rg" {
  count      = local.enable_locks
  name       = "DenyDelete"
  scope      = azurerm_resource_group.rg["${count.index}"].id   
  lock_level = "CanNotDelete"
  notes      = "Deny Delete"
  depends_on = [
    azurerm_resource_group.rg
  ]
}

output "name" {
  value       = azurerm_resource_group.rg[*].name
  description = "Resource group names"
}

output "id" {
  value       = azurerm_resource_group.rg[*].id
  description = "Resource group ids"
}

output "location" {
  value       = azurerm_resource_group.rg[*].location
  description = "Resource group location"
}

```

### 4b. Referencing Values from Other Blocks
If you look at any of the output block, you will see that the properties are derived from “azurerm_resource_group” . The name of the resource block is “rg” and by using the block we can get the attribute from that resource. This is great for keeping things consistent. For example, it’s common to pass a variable value in for the Resource Group’s location and then inherit that value throughout the script by referencing that block’s value.

### 4c. Outputs
After the script is run, outputs will put these values out into the terminal. Terraform output can also be referenced but that’s more advanced and will not be covered in this tutorial.



 
### 4d. Variables
Variables allow configuration values to be injected into the process. This is incredibly useful for deploying to multiple environments or decoupling values from the process. It’s very common to use a Continous Integration (CI) pipeline to deploy Terraform to multiple environments. In this example, we will make the Environment Tag a variable so that can be easily changed.

### 4e. Create a variables.tf file

This will create a variables.tf file with a default environment tag of “Prod”. If you were to leave out the default value then this would prompt you to enter the value before the script can be run. These are often used in CI pipelines.

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
  default = "faa"
  description = "team name - usually refers to line of business "
   validation {
    condition = length(var.team_name) < 5
    error_message = "Shouldn't be more than 4 characters"
  }
}

variable "client_name" {
  type        = string
  description = "client name"
  default     = "bcmp"
}

variable "index" {
  default = 1  
  description = "Resource index - helpful when creating multiple resources with same name at once."
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

variable "extra_tags" {
  type = map
  default = null
  description = "Tags to apply on resource"
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}

variable "enable_locks" {
  type = bool
  default = false
  description = "Apply RG locks if set to true"
}
```
 
## 5. Terraform Commands
Now, is the fun part, we can actually deploy and destroy Terraformed infrastructure and see this work. I’m going to teach you the most basic commands that you will use to create an infrastructure through Terraform. There’s a lot more but this is the bare minimum to get started.

https://www.terraform.io/docs/cli/commands/index.html

### 5a. Init
The terraform init command will download providers and modules and prepare Terraform to be ready to plan and apply infrastructure changes.

```
terraform init
```

### 5b. Plan
Terraform plan allows you to see what changes will be applied to the infrastructure before committing to the change.

```
terraform plan -out main.plan
```

### 5c. Apply
The Terraform apply command applies the infrastructure changes. You will have to type “Yes” in order to commit these changes.

```
terraform apply -auto-approve main.plan
```

After typing “yes”, Terraform will being to create infrastructure. The final outcome should look like this:



### 5d. Destroy
Terraform destroy will remove all infrastructure that is in the Terraform code. So, this will remove the resource group but if there are other resources then those will not be removed.

```
terraform apply -auto-approve -destroy
```

## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: Copy the code to local files and executes all terraform commands (except destroy).
- Exercise 2: Code snippet provided in module creates a resource group without lock. Rerun all terraform commands (except destroy) after enabling lock for resource group. (Note: Do this change trigger a full redeployment of the resource?)
- Exercise 3: Make use of Azurerm backend to move the terraform state file to storage account and container created in lab setup step 2c. (hint: https://www.terraform.io/language/settings/backends/azurerm)
- Exercise 4: Execute terraform destroy with resource group lock enabled.
- Exercise 5: Execute terraform destroy after manually removing the resource group lock 

## :tada: Summary

This module provided an overview of hashicorp configuration language (HCL) and terraform commands.

[Continue >](../modules/module04.md)
