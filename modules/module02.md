# Module 02 - Azure DevOps Platform - Azure Pipelines

[< Previous Module](../modules/module01.md) - **[Home](../README.md)** - [Next Module >](../modules/module02.md)

## :thinking: Prerequisites
* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).
* Signup for Azure DevOps services.
* Create Organization and projects.

## :loudspeaker: Introduction

In this module, you'll learn about Azure Pipelines, a feature of Azure DevOps Platform.

## :dart: Objectives

* What are Azure Pipelines and its key components?
* Create a simple pipelines using yaml syntax.
* Create a release pipeline using classic web interface.
* Convert a release pipelines to yaml pipeline.


##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [What is Azure Pipelines?](#1-what-is-azure-pipelines?) | Azure Administrator |
| 2 | [Define pipelines using classic web interface](#2-define-pipelines-using-classic-web-interface) | Azure Administrator |
| 3 | [Define pipelines using Yaml syntax](#3-define-pipelines-using-yaml-syntax) | Azure Administrator |
| 4 | [Key Components of Azure DevOps pipelines](#4-key-components-of-azure-devops-pipelines) | Azure Administrator |


## 1. What is Azure Pipelines?

Azure Pipelines automatically builds and tests code projects to make them available to others. It works with just about any language or project type. Azure Pipelines combines continuous integration (CI) and continuous delivery (CD) to test and build your code and ship it to any target.

### 1a. Key Components of Azure Pipelines

![image](https://user-images.githubusercontent.com/19226157/147626246-ac2339bc-1378-40b4-873b-228af38bfe5b.png)

- A trigger initiates an Azure DevOps Pipeline to run.
- A pipeline can have many stages. A pipeline can deploy to single or multiple environments(Dev, QA and Production).
- A stage can be specified to manage jobs in a pipeline and each stage has various jobs.
- Each job runs on one agent. It’s also possible that a job doesn’t have an agent.
- Each agent runs a job that may have various steps.
- A step can be anything like a script or task and it is the compact part of a pipeline.
- A task is a pre-bundled script that acts like to publish a build artifact or to call a REST API.
- A run publishes a bunch of files or bundles called an artifact.

In addition, there are few additionals useful components of Azure pipelines are -

- Approvals specifies a set of validations needed before a deployment can be executed. It is used to manage deployments to production environments. You can implement approvals using pipeline environments. Keep in mind, pipeline environments are different from deployment environments.

![image](https://user-images.githubusercontent.com/19226157/147627356-dcea837a-e21b-48cd-a579-3277bf051246.png)

- A library is a collection of build and release assets for an Azure DevOps project. Assets defined in a library can be used in multiple build and release pipelines of the project. The Library tab can be accessed directly in Azure Pipelines. The library contains two types of assets: variable groups and secure files.

![image](https://user-images.githubusercontent.com/19226157/147627421-1aaaf3bf-ce90-4f3a-86b0-4cb223543263.png)

- A service connection to enable devops connectivity with external services.


## 2. Define pipeline using classic web interface

Though this method is deprecated and will be removed in future but it is a good starting point. 

Before we get our hands dirty, let's understand the pipeline objective. 
Pipeline will be used to execute the terraform code (we'll learn about it in next module) that inturn deploy azure services. We are also going to follow couple of best practices - Build generic templates for pipeline execution and use your own scripts wherever possible instead of pre-built tasks. So basically, we are going to build the generic template for terraform code execution which will be used by subsequent deployment pipelines for actual azure service deployment.

Now since, we have the clarity of objective of this exercise, let get on with it.

- Login to Azure DevOps portal and navigate it to right project.

- Click on Pipelines, then release and click on New Pipeline.

![image](https://user-images.githubusercontent.com/19226157/147628419-3c865bb9-44ce-4587-91cd-986df7276c57.png)

- It opens up the pipeline build Wizard, pre-populated with sample templates however, we'll start with empty job.

![image](https://user-images.githubusercontent.com/19226157/147628501-b4005cb4-daf1-4720-b922-1136a21823e4.png)

- It opens up the stage page next, first let's give the name to the stage and close the window. We are going to call this stage "deployToDevelopment"

![image](https://user-images.githubusercontent.com/19226157/147628769-db37ebcd-fe20-4877-aa16-a681a2104b46.png)

- Now if you'll notice, pipeline currently have a job but no tasks. Let's add some tasks to add meaning to this job.

![image](https://user-images.githubusercontent.com/19226157/147628868-4b2ed167-ffbc-4b2e-9777-def1c3a5e137.png)

- First up, you'll see option to configure the Agent. This is the agent that will actually run this pipeline. You have an option to change agent job name, Agent pool (Use default) and specification (Choose ubuntu-latest). Use rest as defaults.

![image](https://user-images.githubusercontent.com/19226157/147629071-3c96586c-c21b-473d-8d2a-d511261f7b21.png)

- Next, click on plus icon on Agent job to add tasks to this job. Basically, we need to following tasks (in the order specified below) to the job
  
  - Task to extract secrets from key vault
  
  - Task to install latest version of terraform.
  
  - Bash script to initialize terraform (terraform init)
  
  - Bash script to generate a terraform execution plan (terraform plan)
  
  - Bash script to apply the terraform plan (terraform apply)

- Click on plus icon and search for "key vault" in Add tasks pane. Click on "Azure Key Vault (Description - Download Azure Key Vault Secrets)" . This task now should be added to the queue. Click on the task to configure it. Give this task a meaningful name, choose the service connection and keyvault from drop down list. Leave rest of the configuration parameters as default. This task will download the secrets from key vaults and set them up as variables to be used in subsequent steps in pipeline.

![image](https://user-images.githubusercontent.com/19226157/147636663-f3c737f0-dd5d-48bf-8fcf-ff4d925df2d3.png)

- Click on plus icon to add another task. This time around, search for terraform and choose first one that pops up in the search. This task most likely show up in marketplace however, it is available to use for free so click on "Get It free" and follow the instructions to install it in your devops organization.

![image](https://user-images.githubusercontent.com/19226157/147631300-040abdea-7b77-4d0f-9125-89ded5cbab99.png)

Come back to your add devops portal, add task pane and refresh it before looking up for terraform again. This time around, choose task named "Terraform tool installer" and click on Add. 

![image](https://user-images.githubusercontent.com/19226157/147631420-001a1904-97c1-4cfe-b140-c0bd290e7241.png)

There is no need to configure this task. This task will automatically fetch the latest version of terraform and install it on pipeline agent.

- Next add a new task and search for "Bash" and click on Add Task. Click on the task to configure it. Click on script type as "Inline" and type the following block of code in script section. 

```
terraform init \
                -reconfigure \
                -backend-config="storage_account_name=$(storage_account_name)" \
                -backend-config="container_name=$(container_name)" \
                -backend-config="key=$(key)" \
                -backend-config="resource_group_name=$(resource_group_name)" \
                -backend-config="subscription_id=$(subscriptionid)" \
                -backend-config="tenant_id=$(tenantid)" \
                -backend-config="client_id=$(clientid)" \
                -backend-config="client_secret=$(clientsecret)"
 ```

Change the display name to "Terraform init"

![image](https://user-images.githubusercontent.com/19226157/147640615-69f176f3-e768-4f4e-a3af-1ed4ed26c8cb.png)

In advanced section of pipeline task, set up the working directory to rg sub-folder in tfcode folder in repository.

![image](https://user-images.githubusercontent.com/19226157/147640631-63486c27-7ab6-4e5b-abbd-31bdd1e5c412.png

This piece of code, make use of variables. Some of these variables - storage_account_name, container_name, key, & resource_group_name, needs to be defined explicitly while others - subscriptionid, tenantid, clientid, clientsecret, references to key secrets that will be downloaded at the beginning of pipeline execution.

- Set up variables for pipeline to use.
  - storage_account_name: Name of the storage account created in Lab setup step 2e.
  - container_name: Name of the container created in Lab setup step 2e.
  - key: Name to be given to terraform state of the resource being deployed. For example - resourceGroup.tfstate
  - resource_group_name: Name of the resource group containing the storage account created in Lab setup step 2e.

![image](https://user-images.githubusercontent.com/19226157/147640428-03110510-e1df-4885-9770-40564706b011.png)

- Next, add another task of Bash script type. Add the following piece of code in inline script.

```
az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
export ARM_CLIENT_ID=$(clientid)
export ARM_CLIENT_SECRET=$(clientsecret)
export ARM_TENANT_ID=$(tenantid)
export AZURE_CLIENT_ID=$(clientid)
export AZURE_CLIENT_SECRET=$(clientsecret)
export AZURE_TENANT_ID=$(tenantid)
export ARM_SUBSCRIPTION_ID=$(subscriptionid)
terraform plan -out $(Build.BuildId).plan

```
Change the display name to "Terraform plan"

In advanced section of pipeline task, set up the working directory to rg sub-folder in tfcode folder in repository.

![image](https://user-images.githubusercontent.com/19226157/147641031-88324342-940b-43fb-8fbb-38d795473c71.png)

- Add another task again of bash script type and add the following piece of code in inline script.

```
az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
export ARM_CLIENT_ID=$(clientid)
export ARM_CLIENT_SECRET=$(clientsecret)
export ARM_TENANT_ID=$(tenantid)
export AZURE_CLIENT_ID=$(clientid)
export AZURE_CLIENT_SECRET=$(clientsecret)
export AZURE_TENANT_ID=$(tenantid)
export ARM_SUBSCRIPTION_ID=$(subscriptionid)
terraform apply -auto-approve $(Build.BuildId).plan

```
Change the display name to "Terraform apply"

In advanced section of pipeline task, set up the working directory to rg sub-folder in tfcode folder in repository.

- Last task is to destroy the resource group, again of bash script type.

```
az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
export ARM_CLIENT_ID=$(clientid)
export ARM_CLIENT_SECRET=$(clientsecret)
export ARM_TENANT_ID=$(tenantid)
export AZURE_CLIENT_ID=$(clientid)
export AZURE_CLIENT_SECRET=$(clientsecret)
export AZURE_TENANT_ID=$(tenantid)
export ARM_SUBSCRIPTION_ID=$(subscriptionid)
terraform apply -auto-approve -destroy
```

Change the display name to "Terraform destroy"

In advanced section of pipeline task, set up the working directory to rg sub-folder in tfcode folder in repository.

- In the last step, click on pipeline tab and add the artifacts for the pipeline. Choose Azure DevOps Repository as artifact and provide repository name and branch name.

![image](https://user-images.githubusercontent.com/19226157/147643159-eff18ef3-e43a-4951-8099-a6b88ce3261b.png)

- Now the pipeline is completed and ready to be deployed. Click on create release to deploy the pipeline. Add the release description and click on create to create the release.
  
![image](https://user-images.githubusercontent.com/19226157/147643264-033ed68f-c1ca-45cb-829e-29b8da1d6eb2.png)

After the release is created, page will present you with hyperlink to release. Click on the link to monitor the job execution.

![image](https://user-images.githubusercontent.com/19226157/147643377-3b779998-0afd-4f0c-bb6d-ce5ea1818f89.png)

Click on stages and then view logs to monitor the execution logs.

![image](https://user-images.githubusercontent.com/19226157/147643438-9fb2516f-575d-44cd-875f-75755c4f53b4.png)

Congratulations! you have successfully created your first pipeline.

## 3. Define pipeline using yaml syntax





## 📚 Additional Reading

Read and understand [how to Plan your organizational structure](https://docs.microsoft.com/en-us/azure/devops/user-guide/plan-your-azure-devops-org-structure?view=azure-devops).


## :tada: Summary

This module provided an overview of how to create a collection, register a source, and trigger a scan.

[Continue >](../modules/module03.md)




