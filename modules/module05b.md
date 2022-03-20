# Module 05a - CI/CD with Data Factory - DevOps Pipeline for CI and CD.

[< Previous Module](../modules/module05a.md) - **[Home](../README.md)** - [Next Module >](../modules/module06.md)

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).
* [Module 05](../modules/module05.md)
* [Module 05a](../module/module05a.md)

## :loudspeaker: Introduction

In this module, you will learn about generating templates from 

## :dart: Objectives

* What is ARM template?
* Generate ARM templates for Data Factory objects
* Create DevOps pipeline to propagate the Data Factory ARM templates to UAT and Production Data Factory.


##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [What is ARM template?](#1-what-is-arm-template?) | NA |
| 2 | [Generate And Publish ARM Template from Data Factory](#2-generate-and-publish-arm-template-from-data-factory) | Azure Administrator |
| 3 | [DevOps Pipeline](#3-devops-pipeline) | Azure Administrator |


## 1. What is ARM template?

If you need a way of deploying infrastructure-as-code to Azure, then Azure Resource Manager (ARM) Templates are the obvious way of doing it simply and repeatedly. They define the objects you want, their types, names and properties in a JSON file which can be understood by the ARM API.

### What is ARM and what are ARM Templates?

Azure is managed using an API: Originally it was managed using the Azure Service Management API or ASM which control deployments of what is termed “Classic”. This was replaced by the Azure Resource Manager or ARM API. The resources that the ARM API manages are objects in Azure such as network cards, virtual machines, hosted databases.

The main benefits of the ARM API are that you can deploy several resources together in a single unit and that the deployments are idempotent, in that the user declares the type of resource, what name to use and which properties it should have; the ARM API will then either create a new object that matches those details or change an existing object which has the same name and type to have the same properties.

ARM Templates are a way to declare the objects you want, the types, names and properties in a JSON file which can be checked into source control and managed like any other code file. ARM Templates are what really gives us the ability to roll out Azure “**Infrastructure as code**”.

### What can ARM templates do? 

An ARM template can either contain the contents of an entire resource group or it can contain one or more resources from a resource group. When a template is deployed, you have the option of either using ‘complete’ or ‘incremental’ mode.

The ‘complete’ mode deletes any objects that do not appear in the template and the resource group you are deploying to. In this scenario, what you get is the ability to know that whenever you deploy you will be in exactly the same state.

The ‘incremental’ deployment uses the template to add additional resources to an existing resource group. The benefit of this is that you don’t lose any infrastructure that is missing from the template but the downside is that you will have to clear up any old resources some other way.

The ideal deployment is ‘complete’ but it does mean that you need to have a good automated deployment pipeline with at least one test environment where you can validate that the template doesn’t rip the heart out of your beautiful production environment.

### What don’t they do?

The ARM API deploys resources to Azure, but doesn’t deploy code onto those resources. For example you can use ARM to deploy a virtual machine with SQL Server already installed but you can’t use ARM to deploy a database from an SSDT DacPac.


## 2. Generate And Publish ARM Template from Data Factory

Now that all kind of validation are successful, time to **merge** this code to master branch. To do that, Click on **Manage** icon and expand the branch option on top left hand side corner. Click on **Create Pull Request**.

![image](https://user-images.githubusercontent.com/19226157/159132370-0da4bcfa-fc33-4ced-abe3-83ca3adb98d6.png)


This should open a pull request form in Azure Devops in new window. Fill out the basic details such as **Title** and **Description**, and then click on **Create** to create the pull request.

![image](https://user-images.githubusercontent.com/19226157/159132414-76b3c93a-de2b-4eea-aa78-f7017b1c13ca.png)

![image](https://user-images.githubusercontent.com/19226157/159132421-b6ce684f-e0a1-46e4-bbcc-8edf9fcaa712.png)

After the request is created, click on **Complete** to finish merging the code to master. When prompted with additional optional, leave them as default and click on **Complete Merge**.

![image](https://user-images.githubusercontent.com/19226157/159132445-4d80cd8f-85d5-4e40-bd4a-f5b7616df7fa.png)

![image](https://user-images.githubusercontent.com/19226157/159132450-9034aa77-7853-496a-8c7e-54cd262330ab.png)

It shouldn’t take too long to complete the merge.

![image](https://user-images.githubusercontent.com/19226157/159132461-d844b0ea-bd33-4147-9a95-1742f2c0f00e.png)

```
To propagate the data factory pipelines from one environment (dev) to another (pre-prod and prod), these pipelines including linked services and datasets needs to be converted into ARM template. Data factory has this feature inbuilt. 
```

Head over to **data factory** and click on **Manage** Icon and switch to **main/master** branch.

![image](https://user-images.githubusercontent.com/19226157/159132481-11e2fa53-6234-4c57-8a75-6cf64c317365.png)

Click on **Publish**, to publish the changes and generate ARM template.

![image](https://user-images.githubusercontent.com/19226157/159132493-0487878d-7fa6-4855-a1f8-ff0230c64b16.png)

Before data factory publish the changes, it generates a report of pending changes. Click **OK** after review.

![image](https://user-images.githubusercontent.com/19226157/159132503-e5c1d5d1-b99a-4676-9d82-62485ef72bb3.png)

![image](https://user-images.githubusercontent.com/19226157/159132507-b050d64f-8695-4348-b898-f53eafa8d22b.png)


Head over to **Azure DevOps portal** to view the generated ARM templates. Click on **adf_publish** branch.

![image](https://user-images.githubusercontent.com/19226157/159132520-7049b901-8281-4f60-8c32-cfc34bad9aed.png)

![image](https://user-images.githubusercontent.com/19226157/159132527-77cd3c03-877f-4aa2-adc5-5f1be0ddffaa.png)


## 3. DevOps Pipeline

```
resources:
 repositories:
   - repository: **<devops_repository_name>**
     name: **<devops_project_name>/<devops_repository_name>**
     ref: '**refs/heads/adf_publish**'
     type: git

stages:
- stage: Build
  jobs:
  - deployment:
    displayName: 'CI Part of the pipeline - Building artifacts.'
    pool:
      name: '**<devops_agent_pool>**'
    dependsOn: ''
    condition: ''
    environment: build
    workspace:
      clean: all
    strategy:
      runOnce:
        deploy:
          steps:
          - checkout: **<devops_repository_name>**
            path: **<devops_repository_name>**
          - task: PublishBuildArtifacts@1
            inputs:
              PathtoPublish: '.'
              ArtifactName: 'drop'
              publishLocation: 'Container'
- stage: Deploy
  jobs:
  - deployment:
    displayName: 'Deploying ARM Template - CD'
    pool:
      name: '**<devops_agent_pool>**'
    dependsOn:
    condition: ''
    environment: build
    workspace:
      clean: all
    strategy:
      runOnce:
        deploy:
          steps:
          - task: AzureResourceManagerTemplateDeployment@3
            displayName: 'ARM Template deployment: Resource Group scope'
            inputs:
              azureResourceManagerConnection: '**<devops_service_connection_name>**'
              subscriptionId: '**<azure_subscription_id>**'
              resourceGroupName: **<target_resource_group_name>**
              location: '**<resource_group_geographical_location>**'
              csmFile: '$(System.ArtifactsDirectory)/../drop/**<devops_repository_name>**/ARMTemplateForFactory.json'
              csmParametersFile: '$(System.ArtifactsDirectory)/../drop/**<devops_repository_name>**/ARMTemplateParametersForFactory.json'
              overrideParameters: '-factoryName "**<target_data_factory_name>**" -SourceA_accountKey "**<target_storage_account_access_key>**" -SourceA_properties_typeProperties_url "https://**<target_storage_account_name>**.dfs.core.windows.net"'

```

## 📚 Additional Reading

<ul>
	<li>https://docs.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery</li>
</ul>

## 🧑‍💼 To-Do Activities

- Exercise 1: Complete the exercise mentioned in [Module 05](../modules/module05.md) and deploy the changes to UAT and PROD data factory using automation pipeline

## :tada: Summary

This module provided an overview of CI/CD with Data Factory.
