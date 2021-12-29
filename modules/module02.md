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

Though this method is deprecated and will not be available in future but it is a good starting point. 

### 2a. Create a service principal

There is no way to directly create a service principal using the Azure portal. When you register an application through the Azure portal, an application object and service principal are automatically created in your home directory or tenant. 

Let's jump straight into creating the identity. If you run into a problem, check the required permissions to make sure your account can create the identity.

- Sign in to your Azure Account through the Azure portal.

- Select Azure Active Directory.

- Select App registrations.

- Select New registration.

- Name the application. Select a supported account type, which determines who can use the application. Under Redirect URI, select Web for the type of application you want to create. Enter the URI where the access token is sent to. You can't create credentials for a Native application. You can't use that type for an automated application. After setting the values, select Register.

![image](https://user-images.githubusercontent.com/19226157/147629724-fcd16d82-883b-4185-8f3e-e7f300a78602.png)

You've created your Azure AD application and service principal.

### 2b. Assign role to service principal on subscription

To access resources in your subscription, you must assign a role to the application. Decide which role offers the right permissions for the application. To learn about the available roles, see Azure built-in roles.

You can set the scope at the level of the subscription, resource group, or resource. Permissions are inherited to lower levels of scope. For example, adding an application to the Reader role for a resource group means it can read the resource group and any resources it contains.

- In the Azure portal, select the level of scope you wish to assign the application to. For example, to assign a role at the subscription scope, search for and select Subscriptions, or select Subscriptions on the Home page.

![image](https://user-images.githubusercontent.com/19226157/147629837-f815c03d-fbc3-44ba-a6b4-efac3a2ce7d5.png)

- Select the particular subscription to assign the application to.

![image](https://user-images.githubusercontent.com/19226157/147629883-a434fcbe-7c07-42c2-bead-85273908ba29.png)

If you don't see the subscription you're looking for, select global subscriptions filter. Make sure the subscription you want is selected for the portal.

- Select Access control (IAM).

- Select Select Add > Add role assignment to open the Add role assignment page.

- Select the Owner role. On next tab which is member tab, Add newly registered application/ service principal as member to the role. Make sure that choosen AD object type is "App". Next click on "Review + Assign" to complete the role assignment.

![image](https://user-images.githubusercontent.com/19226157/147630136-c1c3fa63-532a-453e-967c-92acdf1d6d0d.png)


### 2c. Create a service connection

Complete the following steps to create a service connection for Azure Pipelines.

- Sign in to your organization (https://dev.azure.com/{yourorganization}) and select your project.

- Select Project settings > Service connections.

![image](https://user-images.githubusercontent.com/19226157/147630261-5d5b04f0-68a1-4461-8d7f-178083fb4fbd.png)

- Select + New service connection, select the type of service connection as "Azure Resource Manager", and then select Next.

![image](https://user-images.githubusercontent.com/19226157/147630324-7dc509c7-2320-4d85-8229-21e97296c4f8.png)

- Choose recommended authentication method, i.e. Service principal (Automatic), and then select Next.

![image](https://user-images.githubusercontent.com/19226157/147630352-047f6825-9483-4ca0-be64-5c2e3a23a942.png)

- Give this connection a meaningful name and leave rest of things default.Select Save to create the connection.

![image](https://user-images.githubusercontent.com/19226157/147630453-85a4c9a1-2f1f-479f-a754-96769b51e76b.png)

While trying to save it, it might ask you to authenticate yourself with Azure portal. if so, do the needful and after the succesful authentication, you should be able to see a service connection on devops portal.

![image](https://user-images.githubusercontent.com/19226157/147630632-cdffb6a9-c511-4605-8995-02052cadab62.png)


### 2d. Create Pipeline using Classic web interface 

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

- Click on plus icon and search for "key vault" in Add tasks pane. Click on "Azure Key Vault (Description - Download Azure Key Vault Secrets)" . This task now should be added to the queue. Click on the task to configure it. Give this task a meaningful name, choose the service connection that was created in Step 2c , enter test in keyvault name section and leave rest of the configuration parameters as default.

----------------------- ------------------------------------
## ❗ Note 

Since, we currently don't have any key vault created, you don't have the option to choose from drop down list. 

----------------------------------------------------------------

- Click on plus icon to add another task. This time around, search for terraform and choose first one that pops up in the search. This task most likely show up in marketplace however, it is available to use for free so click on "Get It free" and follow the instructions to install it in your devops organization.

![image](https://user-images.githubusercontent.com/19226157/147631300-040abdea-7b77-4d0f-9125-89ded5cbab99.png)

Come back to your add devops portal, add task pane and refresh it before looking up for terraform again. This time around, choose task named "Terraform tool installer" and click on Add. 

![image](https://user-images.githubusercontent.com/19226157/147631420-001a1904-97c1-4cfe-b140-c0bd290e7241.png)

There is no need to configure this task. This task will automatically fetch the latest version of terraform and install it on pipeline agent.

- Next add a new task and search for "Bash" and click on Add Task. Click on the task to configure it. Click on script type as "Inline" and type the following block of code in script section. 

```
terraform -chdir="${{ parameters.workingDirectory }}" init \
                -plugin-dir="../faa-tf-common-files/plugins" \
                -reconfigure \
                -backend-config="storage_account_name=${{ parameters.backendAzureRmStorageAccountName }}" \
                -backend-config="container_name=${{ parameters.backendAzureRmContainerName }}" \
                -backend-config="key=${{ parameters.backendAzureRmKey }}" \
                -backend-config="resource_group_name=${{ parameters.backendAzureRmResourceGroupName }}" \
                -backend-config="subscription_id=$(subscriptionid)" \
                -backend-config="tenant_id=$(tenantid)" \
                -backend-config="client_id=$(clientid)" \
                -backend-config="client_secret=$(clientsecret)"
 ```



## 📚 Additional Reading

Read and understand [how to Plan your organizational structure](https://docs.microsoft.com/en-us/azure/devops/user-guide/plan-your-azure-devops-org-structure?view=azure-devops).


## :tada: Summary

This module provided an overview of how to create a collection, register a source, and trigger a scan.

[Continue >](../modules/module03.md)




