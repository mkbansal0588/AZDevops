# Module 02 - Azure DevOps Platform - Azure Pipelines

[< Previous Module](../modules/module01.md) - **[Home](../README.md)** - [Next Module >](../modules/module03.md)

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

Before we get our hands dirty, let's understand the pipeline objective. The primary objective for this pipeline will be to read the terraform code from Azure repository and deploy the services to Azure subscription.

Now since, we have the clarity of objective of this exercise, let get on with it.

- Login to Azure DevOps portal and navigate it to right project.

- Click on Pipelines, then release and click on New Pipeline.

![image](https://user-images.githubusercontent.com/19226157/147628419-3c865bb9-44ce-4587-91cd-986df7276c57.png)

- It opens up the pipeline build Wizard, pre-populated with sample templates however, we'll start with empty job.

![image](https://user-images.githubusercontent.com/19226157/147628501-b4005cb4-daf1-4720-b922-1136a21823e4.png)

- It opens up the stage page next, first let's give the name to the stage and close the window. We are going to call this stage "deployToDevelopment"

![image](https://user-images.githubusercontent.com/19226157/147628769-db37ebcd-fe20-4877-aa16-a681a2104b46.png)

- Before we proceed with configuring jobs and tasks, let's add resources/artifacts to this pipeline. Click on "pipeline" tab and "add the artifacts" for the pipeline. Choose Azure DevOps Repository as artifact and provide repository name and branch name.

![image](https://user-images.githubusercontent.com/19226157/147643159-eff18ef3-e43a-4951-8099-a6b88ce3261b.png)

- Next you'll notice, pipeline currently have a job but no tasks. Let's add some tasks to add meaning to this job.

![image](https://user-images.githubusercontent.com/19226157/147628868-4b2ed167-ffbc-4b2e-9777-def1c3a5e137.png)

- First up, you'll see option to configure the Agent. This is the agent that will actually run this pipeline. You have an option to change agent job name, Agent pool (Use default) and specification (Choose ubuntu-latest). Use rest as defaults.

![image](https://user-images.githubusercontent.com/19226157/147629071-3c96586c-c21b-473d-8d2a-d511261f7b21.png)

- Next, click on plus icon on Agent job to add tasks to this job. Basically, we need to following tasks (in the order specified below) to the job
  
  - Task to extract secrets from key vault
  
  - Task to install latest version of terraform.
  
  - Bash script to initialize terraform (terraform init)
  
  - Bash script to generate a terraform execution plan (terraform plan)
  
  - Bash script to apply the terraform plan (terraform apply)
  
  - Bash script to destroy the build azure services (terraform apply -destroy)

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

- Now the pipeline is completed and ready to be deployed. Click on create release to deploy the pipeline. Add the release description and click on create to create the release.
  
![image](https://user-images.githubusercontent.com/19226157/147643264-033ed68f-c1ca-45cb-829e-29b8da1d6eb2.png)

After the release is created, page will present you with hyperlink to release. Click on the link to monitor the job execution.

![image](https://user-images.githubusercontent.com/19226157/147643377-3b779998-0afd-4f0c-bb6d-ce5ea1818f89.png)

Click on stages and then view logs to monitor the execution logs.

![image](https://user-images.githubusercontent.com/19226157/147643438-9fb2516f-575d-44cd-875f-75755c4f53b4.png)

Congratulations! you have successfully created your first pipeline.

## 3. Define pipeline using yaml syntax

In this section of the module, you'll learn to create the Azure pipeline to deploy resources defined in terraform code. It is the same pipeline that we created in Step # 2 of this module however, this time around we'll write the YAML code to build the pipeline.

- Easiest way to find the YAML code for various tasks is to leverage already built release pipeline using web interface. Release pipeline tasks have built in features to translate the task and provide an YAML equivalent.

![image](https://user-images.githubusercontent.com/19226157/147644962-74722a2a-9c42-4fce-af2b-fb59990cf9ec.png)

![image](https://user-images.githubusercontent.com/19226157/147645001-606bfefc-da5c-4c12-9a6a-faf9d62e48c8.png)

So, here is the yaml equivalent code for all of pipeline tasks:

```
variables:
  storage_account_name: 'exampleapp12292021'
  container_name: 'statefiles'
  key: 'resourceGroup.tfstate'
  resource_group_name: 'example-app'
  
steps:
- task: AzureKeyVault@2
  displayName: 'Azure Key Vault: exampleapp12292021'
  inputs:
    azureSubscription: 'example-app-service-connection'
    KeyVaultName: exampleapp12292021

steps:
- task: ms-devlabs.custom-terraform-tasks.custom-terraform-installer-task.TerraformInstaller@0
  displayName: 'Install Terraform latest'

steps:
- bash: |
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
  workingDirectory: '$(System.DefaultWorkingDirectory)/_cambansal0588/tfcode/rg'
  displayName: 'Terraform init'

steps:
- bash: |
   az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
   export ARM_CLIENT_ID=$(clientid)
   export ARM_CLIENT_SECRET=$(clientsecret)
   export ARM_TENANT_ID=$(tenantid)
   export AZURE_CLIENT_ID=$(clientid)
   export AZURE_CLIENT_SECRET=$(clientsecret)
   export AZURE_TENANT_ID=$(tenantid)
   export ARM_SUBSCRIPTION_ID=$(subscriptionid)
   terraform plan -out $(Build.BuildId).plan
  workingDirectory: '$(System.DefaultWorkingDirectory)/_cambansal0588/tfcode/rg'
  displayName: 'Terraform plan'

steps:
- bash: |
   az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
   export ARM_CLIENT_ID=$(clientid)
   export ARM_CLIENT_SECRET=$(clientsecret)
   export ARM_TENANT_ID=$(tenantid)
   export AZURE_CLIENT_ID=$(clientid)
   export AZURE_CLIENT_SECRET=$(clientsecret)
   export AZURE_TENANT_ID=$(tenantid)
   export ARM_SUBSCRIPTION_ID=$(subscriptionid)
   terraform apply -auto-approve $(Build.BuildId).plan
  workingDirectory: '$(System.DefaultWorkingDirectory)/_cambansal0588/tfcode/rg'
  displayName: 'Terraform apply'
  
steps:
- bash: |
   az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
   export ARM_CLIENT_ID=$(clientid)
   export ARM_CLIENT_SECRET=$(clientsecret)
   export ARM_TENANT_ID=$(tenantid)
   export AZURE_CLIENT_ID=$(clientid)
   export AZURE_CLIENT_SECRET=$(clientsecret)
   export AZURE_TENANT_ID=$(tenantid)
   export ARM_SUBSCRIPTION_ID=$(subscriptionid)
   terraform apply -auto-approve -destroy
  workingDirectory: '$(System.DefaultWorkingDirectory)/_cambansal0588/tfcode/rg'
  displayName: 'terraform destroy'
  
  ```

- Next, we need to find the YAML code to add a [Stage](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/stages?view=azure-devops&tabs=yaml) and [Job](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/deployment-jobs?view=azure-devops).

```
stages:
- stage: A
  pool: StageAPool
  jobs:
  - job: A1 # will run on "StageAPool" pool based on the pool defined on the stage
  - job: A2 # will run on "JobPool" pool
    pool: JobPool
    
 jobs:
- deployment: string   # name of the deployment job, A-Z, a-z, 0-9, and underscore. The word "deploy" is a keyword and is unsupported as the deployment name.
  displayName: string  # friendly name to display in the UI
  pool:                # not required for virtual machine resources
    name: string       # Use only global level variables for defining a pool name. Stage/job level variables are not supported to define pool name.
    demands: string | [ string ]
  workspace:
    clean: outputs | resources | all # what to clean up before the job runs
  dependsOn: string
  condition: string
  continueOnError: boolean                # 'true' if future jobs should run even if this job fails; defaults to 'false'
  container: containerReference # container to run this job inside
  services: { string: string | container } # container resources to run as a service container
  timeoutInMinutes: nonEmptyString        # how long to run the job before automatically cancelling
  cancelTimeoutInMinutes: nonEmptyString  # how much time to give 'run always even if cancelled tasks' before killing them
  variables: # several syntaxes, see specific section
  environment: string  # target environment name and optionally a resource name to record the deployment history; format: <environment-name>.<resource-name>
  strategy:
    runOnce:    #rolling, canary are the other strategies that are supported
      deploy:
        steps: [ script | bash | pwsh | powershell | checkout | task | templateReference ]
```

- Lastly, we need to add [repositories](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/resources?view=azure-devops&tabs=schema) to specify the pipeline resources.

```
resources:
  repositories:
  - repository: string  # identifier (A-Z, a-z, 0-9, and underscore)
    type: enum  # see the following "Type" topic
    name: string  # repository name (format depends on `type`)
    ref: string  # ref name to use; defaults to 'refs/heads/main'
    endpoint: string  # name of the service connection to use (for types that aren't Azure Repos)
    trigger:  # CI trigger for this repository, no CI trigger if skipped (only works for Azure Repos)
      branches:
        include: [ string ] # branch names which trigger a build
        exclude: [ string ] # branch names which won't
      tags:
        include: [ string ] # tag names which trigger a build
        exclude: [ string ] # tag names which won't
      paths:
        include: [ string ] # file paths which must match to trigger a build
        exclude: [ string ] # file paths which won't trigger a build
```

- So the pipeline roughly translate to following YAML code.

```
variables:
  storage_account_name: 'exampleapp12292021'
  container_name: 'statefiles'
  key: 'resourceGroup.tfstate'
  resource_group_name: 'example-app'

resources:
  repositories:
  - repository: cambansal0588 #Change it
    type: git
    name: cambansal0588/cambansal0588 # change it



stages:
- stage: 'deploymentToDevelopment'
  jobs:
  - deployment: 
    displayName: 'Deploying ResourceGroup'
    pool: 
      name: 'Azure Pipelines'
    environment: build #changeit
    workspace:
      clean: all
    strategy:
      runOnce:
        deploy:
          steps:
          - checkout: self
            path: '_cambansal0588' #changeit
            
          - task: AzureKeyVault@2
            displayName: 'Azure Key Vault: exampleapp12292021' # changeit
            inputs:
              azureSubscription: 'example-app-service-connection' #changeit
              KeyVaultName: exampleapp12292021 # changeit

          - task: ms-devlabs.custom-terraform-tasks.custom-terraform-installer-task.TerraformInstaller@0
            displayName: 'Install Terraform latest'


          - bash: |
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
            workingDirectory: '$(System.DefaultWorkingDirectory)/tfcode/rg'
            displayName: 'Terraform init'
            
          - bash: |
              az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
              export ARM_CLIENT_ID=$(clientid)
              export ARM_CLIENT_SECRET=$(clientsecret)
              export ARM_TENANT_ID=$(tenantid)
              export AZURE_CLIENT_ID=$(clientid)
              export AZURE_CLIENT_SECRET=$(clientsecret)
              export AZURE_TENANT_ID=$(tenantid)
              export ARM_SUBSCRIPTION_ID=$(subscriptionid)
              terraform plan -out $(Build.BuildId).plan
            workingDirectory: '$(System.DefaultWorkingDirectory)/tfcode/rg'
            displayName: 'Terraform plan'


          - bash: |
              az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
              export ARM_CLIENT_ID=$(clientid)
              export ARM_CLIENT_SECRET=$(clientsecret)
              export ARM_TENANT_ID=$(tenantid)
              export AZURE_CLIENT_ID=$(clientid)
              export AZURE_CLIENT_SECRET=$(clientsecret)
              export AZURE_TENANT_ID=$(tenantid)
              export ARM_SUBSCRIPTION_ID=$(subscriptionid)
              terraform apply -auto-approve $(Build.BuildId).plan
            workingDirectory: '$(System.DefaultWorkingDirectory)/tfcode/rg'
            displayName: 'Terraform Apply'
            
            
          - bash: |
              az login --service-principal -u $(clientid) -p $(clientsecret) --tenant $(tenantid)
              export ARM_CLIENT_ID=$(clientid)
              export ARM_CLIENT_SECRET=$(clientsecret)
              export ARM_TENANT_ID=$(tenantid)
              export AZURE_CLIENT_ID=$(clientid)
              export AZURE_CLIENT_SECRET=$(clientsecret)
              export AZURE_TENANT_ID=$(tenantid)
              export ARM_SUBSCRIPTION_ID=$(subscriptionid)
              terraform apply -auto-approve -destroy
            workingDirectory: '$(System.DefaultWorkingDirectory)/tfcode/rg'
            displayName: 'Terraform destroy'
```

- Copy this code and click on Pipelines under Pipelines , and then click on create new pipeline.

![image](https://user-images.githubusercontent.com/19226157/147649338-34977f65-e63b-466e-b6c2-d0b286e407d7.png)

- Connect to Azure Repos Git. Choose the existing repository and then click on starter pipeline. Wipe the code from starter pipeline clean and the paste the copied content from here.
Then Click on "Save and Run".

![image](https://user-images.githubusercontent.com/19226157/147649658-4fe5681c-c68f-4fa8-87cd-fefe94d829ca.png)


- Pipeline may request for authorization before it can actually run.

![image](https://user-images.githubusercontent.com/19226157/147648245-a786bf12-0f20-4894-a063-e531026cd98d.png)

Click View and new windows opens up with option to Permit pipeline execution.

![image](https://user-images.githubusercontent.com/19226157/147648285-3d233699-7dbe-4bfd-b6b5-ba188aeb93c2.png)

- After pipeline obtain all the necessary permissions, it should start the execution. A successful execution will look something like this in screenshot -

![image](https://user-images.githubusercontent.com/19226157/147648896-0115543e-0f2c-4acf-aea3-b2997645ff92.png)

Congratulations, you have created your first yaml pipeline.

## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: This pipeline generates the terraform plan and then applies in a single step however, in an ideal scenario, we would like to review the plan and wait for explicit approval before this plan is applied. Repurpose this pipeline to implement the desired solution. (Hint - Make use of pipeline environments)

## :tada: Summary

This module provided an overview of how to create a legacy and yaml based Azure devops pipelines..

[Continue >](../modules/module03.md)




