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
| 3 | [Terraform deployment variables files review](#3-terraform-deployment-variables-files-review) | Azure Administrator |
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

Though we can complete the deployment in one pipeline however, I have broken the deployment down into two different pipelines. First pipeline a.k.a build pipeline generates the plan and wait for explicit approvals from approvers before second pipeline a.k.a deployment pipeline deploy the azure services.

- Build Pipeline: This pipeline consists of following steps
  1. Download repository to local filesystem.
  2. Download secrets from key vault.
  3. Install terraform binaries.
  4. Terraform initialization (init).
  5. Terraform deploy plan generation (plan).

```
parameters:
  - name: moduleName
    displayName: "Module Name to Build"
    type: string
    default: ""
  - name: workingDirectory
    displayName: "Working DIrectory"
    type: string
    default: ""
  - name: backendServiceArm
    displayName: "Service Connection to use for backend."
    type: string
    default: ""
  - name: backendAzureRmResourceGroupName
    displayName: "Resource Group for Backend storage account"
    type: string
    default: ""
  - name: backendAzureRmStorageAccountName
    displayName: "Backend storage account"
    type: string
    default: ""
  - name: backendAzureRmContainerName
    displayName: "Container name to store terraform state file"
    type: string
    default: ""
  - name: backendAzureRmKey
    displayName: "State File Name"
    type: string
    default: ""
  - name: keyvault
    displayName: "Name of keyvault to pull the secrets and client id to be used for making connection to Azure for backend storage"
    type: string
    default: ""
  - name: dependsOn
    displayName: "Define Dependency"
    type: string
    default: ""
  - name: condition
    displayName: "Condition to run a job"
    type: string
    default: ""
  - name: env
    displayName: "Environment up for deployment"
    type: string
    default: ""
  - name: deploymentFolder
    displayName: "Repository to use to trigger the deployment."
    type: string
    default: ""
  - name: secrets
    displayName: "secrets to download"
    type: string
    default: "tenantid,subscriptionid,clientsecret,clientid"
  - name: mdname
    displayName: "Name of the module"
    type: string

jobs:
  - deployment: 
    displayName: 'Building Module ${{ parameters.mdname }}'
    pool:
      name: 'Azure Pipelines'
    dependsOn: '${{ parameters.dependsOn }}'
    condition: '${{ parameters.condition }}'
    environment: build
    workspace:
      clean: all
    strategy:
      runOnce:
        deploy:
          steps:
          - checkout: self
            path: repo
            
          - task: AzureKeyVault@1
            inputs:
              azureSubscription: '${{ parameters.backendServiceArm }}'
              KeyVaultName: '${{ parameters.keyvault }}'
              SecretsFilter: '${{ parameters.secrets }}'
              runAsPreJob: true
            displayName: 'Get key vault secrets as pipeline variables'

          - task: ms-devlabs.custom-terraform-tasks.custom-terraform-installer-task.TerraformInstaller@0
            displayName: 'Install Terraform latest'
            
          - script: |
              terraform -chdir="${{ parameters.workingDirectory }}" init \
                -reconfigure \
                -backend-config="storage_account_name=${{ parameters.backendAzureRmStorageAccountName }}" \
                -backend-config="container_name=${{ parameters.backendAzureRmContainerName }}" \
                -backend-config="key=${{ parameters.backendAzureRmKey }}" \
                -backend-config="resource_group_name=${{ parameters.backendAzureRmResourceGroupName }}" \
                -backend-config="subscription_id=$(subscriptionid)" \
                -backend-config="tenant_id=$(tenantid)" \
                -backend-config="client_id=$(clientid)" \
                -backend-config="client_secret=$(clientsecret)"
            displayName: Terraform Init

          - script: |
              az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
              export ARM_CLIENT_ID=$(clientid)
              export ARM_CLIENT_SECRET=$(clientsecret)
              export ARM_TENANT_ID=$(tenantid)
              export AZURE_CLIENT_ID=$(clientid)
              export AZURE_CLIENT_SECRET=$(clientsecret)
              export AZURE_TENANT_ID=$(tenantid)
              export ARM_SUBSCRIPTION_ID=$(subscriptionid)
              terraform -chdir="${{ parameters.workingDirectory }}" plan -var-file="$(Agent.BuildDirectory)/repo/tfcode/${{ parameters.deploymentFolder }}/${{ parameters.moduleName }}/variables-${{ parameters.env }}.tfvars" -out $(Build.BuildId).plan
            displayName: Terraform Plan
```

Since this is a template, I have parameterized the variables used in the script inside the pipeline template.

- Deployment Pipeline: This pipeline actually deploys the pipeline. It consists of all the steps of build pipeline and an additional step on terraform deployment a.k.a apply.

```
parameters:
- name: moduleName
  displayName: "Module Name to deploy"
  type: string
  default: ""
- name: workingDirectory
  displayName: "Working DIrectory"
  type: string
  default: ""
- name: dependsOn
  displayName: "Define job Dependency"
  type: string
  default: ""
- name: condition
  displayName: "Condition to run a job"
  type: string
  default: ""
- name: backendServiceArm
  displayName: "Service connection for backend service"
  type: string
  default: ""
- name: backendAzureRmResourceGroupName
  displayName: "Resource Group for Backend storage account"
  type: string
  default: ""
- name: backendAzureRmStorageAccountName
  displayName: "Backend storage account"
  type: string
  default: ""
- name: backendAzureRmContainerName
  displayName: "Container name to store terraform state file"
  type: string
  default: ""
- name: backendAzureRmKey
  displayName: "State File Name"
  type: string
  default: ""
- name: keyvault
  displayName: "Name of keyvault to pull the secrets and client id to be used for making connection to Azure for backend storage"
  type: string
  default: ""
- name: env
  displayName: "Environment up for deployment"
  type: string
  default: ""
- name: deploymentFolder
  displayName: "Repository to use to trigger the deployment."
  type: string
  default: ""
- name: secrets
  displayName: "secrets to download"
  type: string
  default: "tenantid,subscriptionid,clientsecret,clientid"
- name: mdname
  displayName: "Name of the module"
  type: string

jobs:
  - deployment: 
    displayName: 'Deploy Module ${{ parameters.mdname }}'
    pool:
      name: 'Azure Pipelines'
    dependsOn: '${{ parameters.dependsOn }}'
    condition: '${{ parameters.condition }}'
    environment: deploy
    workspace:
      clean: all
    strategy:
      runOnce:
        deploy:
          steps:  
          - checkout: self
            path: repo

          - task: AzureKeyVault@1
            inputs:
              azureSubscription: '${{ parameters.backendServiceArm }}'
              KeyVaultName: '${{ parameters.keyvault }}'
              SecretsFilter: '${{ parameters.secrets }}'
              runAsPreJob: true
            displayName: 'Get key vault secrets as pipeline variables'

          - task: ms-devlabs.custom-terraform-tasks.custom-terraform-installer-task.TerraformInstaller@0
            displayName: 'Install Terraform latest'

          - script: |
              terraform -chdir="${{ parameters.workingDirectory }}" init \
                -reconfigure \
                -backend-config="storage_account_name=${{ parameters.backendAzureRmStorageAccountName }}" \
                -backend-config="container_name=${{ parameters.backendAzureRmContainerName }}" \
                -backend-config="key=${{ parameters.backendAzureRmKey }}" \
                -backend-config="resource_group_name=${{ parameters.backendAzureRmResourceGroupName }}" \
                -backend-config="subscription_id=$(subscriptionid)" \
                -backend-config="tenant_id=$(tenantid)" \
                -backend-config="client_id=$(clientid)" \
                -backend-config="client_secret=$(clientsecret)"
            displayName: Terraform Init

          - script: |
              az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
              export ARM_CLIENT_ID=$(clientid)
              export ARM_CLIENT_SECRET=$(clientsecret)
              export ARM_TENANT_ID=$(tenantid)
              export AZURE_CLIENT_ID=$(clientid)
              export AZURE_CLIENT_SECRET=$(clientsecret)
              export AZURE_TENANT_ID=$(tenantid)
              export ARM_SUBSCRIPTION_ID=$(subscriptionid)
              terraform -chdir="${{ parameters.workingDirectory }}" plan -var-file="$(Agent.BuildDirectory)/repo/tfcode/${{ parameters.deploymentFolder }}/${{ parameters.moduleName }}/variables-${{ parameters.env }}.tfvars" -out $(Build.BuildId).plan      
            displayName: Terraform Plan

          - script: |
              az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
              export ARM_CLIENT_ID=$(clientid)
              export ARM_CLIENT_SECRET=$(clientsecret)
              export ARM_TENANT_ID=$(tenantid)
              export AZURE_CLIENT_ID=$(clientid)
              export AZURE_CLIENT_SECRET=$(clientsecret)
              export AZURE_TENANT_ID=$(tenantid)
              export ARM_SUBSCRIPTION_ID=$(subscriptionid)
              terraform -chdir="${{ parameters.workingDirectory }}" apply -auto-approve -var-file="$(Agent.BuildDirectory)/repo/tfcode/${{ parameters.deploymentFolder }}/${{ parameters.moduleName }}/variables-${{ parameters.env }}.tfvars" -out $(Build.BuildId).plan
            displayName: Terraform Apply
```

Now, we are familiar with deployment template. Let's put this template into action.

## 3. Terraform deployment variables files review

Now you have the terraform code to deploy the azure modules and you have template pipelines which have the steps to execute the code but how will you deploy the same module in three different environments (Dev, Pre-Prod and Production). Answer is simple - by overriding the module variables as runtime.

So, before we put the template into action, it is important to understand the variables file. 

- The way, template pipeline is designed, it expect the runtime variables in certain folders (tfcode/deployment/{adls|kv|rg|adf}) and in certain files (variables-{de|pp|pr}.tfvars) so please don't change the location and name of the variables files.

- Each folder inside /tfcode/deployment folder represent a azure module that will be deployed.

- Each module folder contains, three variables file - one for each environment (Dev|de, Pre-prod|pp and prod|pr).

- Currently, all variables files inside the module are identical. You can make changes to variables files to simulate multiple environments into same subscription however, in a typical customer environment, you'll usually find different subscriptions for production and non-production service deployment.

Sample Varibale file:
```
team_name = "ops"
client_name = "bcmp"
index = 1
counter = 1
location = "canadacentral"
environment = "de"
extra_tags = {}
public_network_enabled = true
managed_virtual_network_enabled = false
resource_group_name = "rf-ops-bcmp-de-cacn-001"
```

## 4. Deployment pipeline review

Now is the time to put everything that have learnt so far together and create the deployment pipeline. We've defined two files in deployment folder:

- pipeline.yaml: This pipeline calls the both template pipelines (build and deploy) one after another (dependency) and passes the run time argument. 

```
name: Azure Resource deployment

variables:
  - template: variables.yaml

parameters:
  - name: stages
    displayName: "Various Stage to execute in pipeline."
    type: object
    default: 
      - rg
      - adls
      - kv
      - adf
  
  - name: deploymentType
    displayName: "Type of deployment"
    type: string
    default: bulkDeployment
  
  - name: bu
    displayName: "Name of business unit"
    type: string
    default: bcmp

  - name: action
    displayName: "Action to perform. Default value is build. Allowed values of build and destroy"
    type: string
    default: build
    values:
    - build
    - destroy

resources:
 repositories:
   - repository: cambansal0588             // change it
     name: cambansal0588/cambansal0588     // change it
     ref: '$(Build.SourceBranch)'
     type: git
     trigger:
      branches:
        include:
          - master
          - releases/*
      paths:
        include:
          - *


stages:
- ${{ each stage in parameters.stages }}:
  - ${{ if eq(parameters.action, 'build') }}:
    - stage: '${{ stage }}_build'
      jobs:
      - template: ../template/pipeline.build.yaml
        parameters:
          mdname: '${{ stage }}'
          moduleName: '${{ stage }}'
          workingDirectory: '$(Agent.BuildDirectory)/repo/tfcode/${{ stage }}'
          dependsOn: ''
          condition: ''
          deploymentFolder: 'deployment'
          ${{ if eq(variables['Build.SourceBranch'], 'refs/heads/main') }}:
            backendServiceArm: '${{ variables.pp_backendServiceArm }}'
            backendAzureRmResourceGroupName: '${{ variables.pp_backendAzureRmResourceGroupName }}'
            backendAzureRmStorageAccountName: '${{ variables.pp_backendAzureRmStorageAccountName }}'
            backendAzureRmContainerName: '${{ variables.pp_backendAzureRmContainerName }}'
            backendAzureRmKey: '${{ parameters.deploymentType }}-${{ parameters.bu }}-${{ stage }}-pp.tfstate'
            keyvault: '${{ variables.pp_keyvault }}'
            env: '${{ variables.pp_env }}'
          ${{ if startsWith(variables['Build.SourceBranch'], 'refs/heads/features') }}:
            backendServiceArm: ${{ variables.de_backendServiceArm }}
            backendAzureRmResourceGroupName: ${{ variables.de_backendAzureRmResourceGroupName }}
            backendAzureRmStorageAccountName: ${{ variables.de_backendAzureRmStorageAccountName }}
            backendAzureRmContainerName: ${{ variables.de_backendAzureRmContainerName }}
            backendAzureRmKey: ${{ parameters.deploymentType }}-${{ parameters.bu }}-${{ stage }}-de.tfstate
            keyvault: ${{ variables.de_keyvault }}
            env: ${{ variables.de_env }}
          ${{ if startsWith(variables['Build.SourceBranch'], 'refs/heads/releases') }}:
            backendServiceArm: ${{ variables.pr_backendServiceArm }}
            backendAzureRmResourceGroupName: ${{ variables.pr_backendAzureRmResourceGroupName }}
            backendAzureRmStorageAccountName: ${{ variables.pr_backendAzureRmStorageAccountName }}
            backendAzureRmContainerName: ${{ variables.pr_backendAzureRmContainerName }}
            backendAzureRmKey: '${{ parameters.deploymentType }}-${{ parameters.bu }}-${{ stage }}-pr.tfstate'
            keyvault: ${{ variables.pr_keyvault }}
            env: ${{ variables.pr_env }}
  
    - stage : ${{ stage }}_deploy
      dependsOn: ${{ stage }}_build
      jobs:
      - template: ../template/pipeline.deploy.yaml
        parameters:
          mdname: '${{ stage }}'
          moduleName: '${{ stage }}'
          workingDirectory: '$(Agent.BuildDirectory)/repo/tfcode/${{ stage }}'
          dependsOn: ''
          condition: ''
          deploymentFolder: 'deployment'
          ${{ if eq(variables['Build.SourceBranch'], 'refs/heads/main') }}:
            backendServiceArm: '${{ variables.pp_backendServiceArm }}'
            backendAzureRmResourceGroupName: '${{ variables.pp_backendAzureRmResourceGroupName }}'
            backendAzureRmStorageAccountName: '${{ variables.pp_backendAzureRmStorageAccountName }}'
            backendAzureRmContainerName: '${{ variables.pp_backendAzureRmContainerName }}'
            backendAzureRmKey: '${{ parameters.deploymentType }}-${{ parameters.bu }}-${{ stage }}-pp.tfstate'
            keyvault: '${{ variables.pp_keyvault }}'
            env: '${{ variables.pp_env }}'
          ${{ if startsWith(variables['Build.SourceBranch'], 'refs/heads/features') }}:
            backendServiceArm: ${{ variables.de_backendServiceArm }}
            backendAzureRmResourceGroupName: ${{ variables.de_backendAzureRmResourceGroupName }}
            backendAzureRmStorageAccountName: ${{ variables.de_backendAzureRmStorageAccountName }}
            backendAzureRmContainerName: ${{ variables.de_backendAzureRmContainerName }}
            backendAzureRmKey: ${{ parameters.deploymentType }}-${{ parameters.bu }}-${{ stage }}-de.tfstate
            keyvault: ${{ variables.de_keyvault }}
            env: ${{ variables.de_env }}
          ${{ if startsWith(variables['Build.SourceBranch'], 'refs/heads/releases') }}:
            backendServiceArm: ${{ variables.pr_backendServiceArm }}
            backendAzureRmResourceGroupName: ${{ variables.pr_backendAzureRmResourceGroupName }}
            backendAzureRmStorageAccountName: ${{ variables.pr_backendAzureRmStorageAccountName }}
            backendAzureRmContainerName: ${{ variables.pr_backendAzureRmContainerName }}
            backendAzureRmKey: '${{ parameters.deploymentType }}-${{ parameters.bu }}-${{ stage }}-pr.tfstate'
            keyvault: ${{ variables.pr_keyvault }}
            env: ${{ variables.pr_env }}
```

Did you notice that this pipeline reads the variables based on the branch used for deployment and then deploys the service to a specific deployment environment?

- variables.yaml: this is the variables file for the pipeline.

```
variables:
  de_backendServiceArm: example-app-service-connection
  de_keyvault: exampleapp12292021
  de_env: de
  de_backendAzureRmResourceGroupName: example-app
  de_backendAzureRmStorageAccountName: exampleapp12292021
  de_backendAzureRmContainerName: statefiles

  pp_backendServiceArm: example-app-service-connection
  pp_backendAzureRmResourceGroupName: example-app
  pp_backendAzureRmStorageAccountName: exampleapp12292021
  pp_backendAzureRmContainerName: statefiles
  pp_keyvault: exampleapp12292021
  pp_env: pp

  pr_backendServiceArm: example-app-service-connection
  pr_backendAzureRmResourceGroupName: example-app
  pr_backendAzureRmStorageAccountName: exampleapp12292021
  pr_backendAzureRmContainerName: statefiles
  pr_keyvault: exampleapp12292021
  pr_env: pr
```


## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: Make changes to pre-production and production terraform module for some/all the modules and deploy two additional sets of resource groups.

## :tada: Summary

This module provided an overview of how to do terraform deployment at scale.
