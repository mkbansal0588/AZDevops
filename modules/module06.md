# Module 05 - CI/CD with Databricks - Environment setup

[< Previous Module](../modules/module05b.md) - **[Home](../README.md)** - [Next Module >](../modules/module06a.md)

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).


## :loudspeaker: Introduction

In this module, you will learn about CI/CD process with Databricks

## :dart: Objectives

* Create Resource Groups
* Create Databricks instances.
* Create storage accounts.
* Create a dedicated repository for Databricks notebooks and external jars.

##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [Objective](#1-objective) | NA |
| 2 | [Setting up the Azure environment](#2-setting-up-the-azure-environment) | Azure Administrator |
| 3 | [Resource Group](#3-resource-group) | Azure Administrator |
| 4 | [Azure Databricks Instances](#4-azure-databricks-instances) | Azure Administrator |
| 5 | [Storage Accounts](#5-storage-accounts) | Azure Administrator |
| 6 | [Create Dedicated Repository for Databricks](#6-create-dedicated-repository-for-databricks) | Azure Administrator |


## 1. Objective

Objective of this three part series (this module followed by other two) is to demonstrate CI/CD with Databricks.

The diagram below is a simple example of an Azure Databricks pipeline. In this example, we want to move a single CSV file from blob storage into anotehr storage account. This activity is done through an Azure Databricks. 

![image](https://user-images.githubusercontent.com/19226157/160514117-ca2bd1b7-9453-4ea7-98c5-ecb636022860.png)

In this particular module, we'll focus on environment set up.

## 2. Setting up the Azure environment


There are several things to consider before starting. You will need access to an Azure Subscription with the ability to create resource groups as well as resources with the “Owner” role assignment. Without the “Owner” privileges, you will not be able to create a service principal that provides DevOps access to your Data Factories within your Resource groups.

We will start by creating three resource groups as well as three data factories. Each pair will resemble one of the three environments. This can be done through the Azure Portal. Keep in mind, Resource Group names have to be unique in your subscription, whereas Data Factories must be unique across Azure.

For this walkthrough, we will follow the following naming scheme for our resources:

```
<Your Initials>-<Project>-<Environment>-<Resource>

```

## 3. Resource Group 

With the naming scheme in mind, we will create three Resource Groups with the following names (do not forget to use your initials):

```
“<Initials>-databricks-dev-rg”  

“<Initials>-databricks-uat-rg”

“<Initials>-databricks-prod-rg”
 
 ```

### 3.1 Creating the DEV Resource Group

Once logged into Azure, on top of the home page click on “**Create a resource**”

create a resource

Using the search bar, search for “**Resource Group**” and select “**Resource Group**” from the search results.

Once in the “**Resource Group**” resource information page, click “**Create**”.

On the “**Create a resource group**” page there will be three fields that need to be filled out:

**Subscription** – Choose your subscription from the list

**Resource Group** – {initials}-databricks-dev-rg
 
**Region** – Select the Region that is most appropriate to your current location.

The result should look something like this:
 
![image](https://user-images.githubusercontent.com/19226157/159130672-972c624f-51a2-4c06-9cf3-198c01060371.png)

create a resource group
 
Click on “**Review + Create**”.

You should see a green bar on the top of the page that says, “Validation passed”.

Click “**Create**” at the bottom of the page.


### 3.2 Creating the UAT and PROD Resource Groups
 
Now that we have created our first resource group, follow the same steps to create the UAT and PROD Resource Groups:

```
“<Initials>-databricks-uat-rg”

“<Initials>-databricks-prod-rg”
```

Once you have created all three Resource Groups, you should see them in your azure portal:

![image](https://user-images.githubusercontent.com/19226157/159130819-c714fc92-91f7-45bd-8e6f-0f7377199d48.png)

## 4. Azure Databricks Instances

Now we will start creating the necessary Data Factories in each respective Resource Group that we created.

With the naming scheme in mind, we will create three Data Factories with the following names (do not forget to use your initials):

```
“<Initials>-warehouse-dev-df”

“<Initials>-warehouse-uat-df”

“<Initials>-warehouse-prod-df”
```

***Important*** Since Azure Databricks workspace names must be unique across all of Azure, you might need to add a random number(s) to the end of your initials for it to be unique. This will not cause any issues going forward.

### 4.1 Creating the DEV Databricks instance

On top of the Azure home page click on “**Create a resource**”

![image](https://user-images.githubusercontent.com/19226157/159130912-e8f48916-b7fc-4cae-9e06-1d6d29c579c9.png)


Using the search bar, search for “Azure Databricks” and select “**Azure Databricks**” from the search results.

Once in the “**Azure Databricks**” resource information page, click “**Create**”.

On the “**Create an Azure Databricks Workspace**” page there will be five fields that need to be filled out:

**Subscription** – Choose your subscription from the list

**Resource Group** – Select “**{Initials}-databricks-dev-rg**” from the drop-down menu.

**Region** – Select the Region that is most appropriate to your current location.

**Name** - {Initials}-databricks-dev-db

**Pricing Tier** -Trial (Premium - 14-Days Free DBUs)

The result should look something like this:

![image](https://user-images.githubusercontent.com/19226157/160509576-166b8384-729c-48e8-99d8-42755ad7afa6.png)

Click on “**Review + Create**”.

You should see a green bar on the top of the page that says, “**Validation passed**”.

![image](https://user-images.githubusercontent.com/19226157/160509623-0c1dbf9f-13a9-4055-a1f7-579d48c53502.png)

Click “**Create**” at the bottom of the page.

### 4.2 Creating UAT and PROD Databricks Instances

Now that we have created our first Databricks workspce, follow the same steps to create the UAT and PROD workspaces in their corresponding Resource Group:

```
“<Initials>-databricks-uat-db”

“<Initials>-databricks-prod-db”
```

Once completed, you will be able to see one Databricks workspace in each Resource Group. 

## 5. Storage Accounts

Next step in the set up process is creation of storage accounts. Just like, data factories, we'll need to create three different storage accounts each designated to dev, pre-prod and prod environment respectively.

### 5.1 Creating the DEV Storage Account

On top of the Azure home page click on “**Create a resource**”

![image](https://user-images.githubusercontent.com/19226157/159130912-e8f48916-b7fc-4cae-9e06-1d6d29c579c9.png)

Using the search bar, search for “**Storage Account**” and select “**Storage Account**” from the search results.

Once in the “**Storage Account**” resource information page, click “**Create**”.

**Subscription** – Choose your subscription from the list

**Resource Group** – Select “**{Initials}-databricks-dev-db**” from the drop-down menu.

**Region** – Select the Region that is most appropriate to your current location.

**Name** - {Initials}databricksdevsa

![image](https://user-images.githubusercontent.com/19226157/159146054-73547837-d4ee-457c-bda6-82df09204696.png)

In **Advanced** tab, make sure to tick the checkbox of **Data Lake Storage Gen2**

![image](https://user-images.githubusercontent.com/19226157/159146089-1646b271-5797-43c8-8942-fc276f8c49d0.png)

Click on “**Review + Create**”.

You should see a green bar on the top of the page that says, “**Validation passed**”.

Click “**Create**” at the bottom of the page.

### 5.2 Add Containers in Storage Account

In next step, we’ll add two container in storage account.

Head over to azure portal and look up the storage account with name.

![image](https://user-images.githubusercontent.com/19226157/159146223-0e5fdba8-5076-4416-a4f8-9757362e09ca.png)

Click on the storage account in question and then click on **Containers** under **Data Storage** section. 

You may or may not container inside the storage account, but we’ll still create two new containers nonetheless. Click on **+Container** to add a new container.

![image](https://user-images.githubusercontent.com/19226157/159146258-03277ebc-194a-463c-ac43-00aa406a03b9.png)

Create two containers. Name both of them as **sourcedata** and **destinationdata** respectively.

![image](https://user-images.githubusercontent.com/19226157/159146271-bf1d23c8-88af-40e7-b03f-7aebdeb4166f.png)

![image](https://user-images.githubusercontent.com/19226157/159146289-fa2eb339-f224-43d3-bc1b-8ec415f57eea.png)

![image](https://user-images.githubusercontent.com/19226157/159146310-2d6a8221-e538-4258-9dc4-04af23c68d9e.png)

### 5.3 Upload some CSV Files

Download these three files.

[winequality-red (1).csv](https://github.com/mkbansal0588/AZDevops/files/8310534/winequality-red.1.csv)
[winequality-red.csv](https://github.com/mkbansal0588/AZDevops/files/8310535/winequality-red.csv)
[winequality-white.csv](https://github.com/mkbansal0588/AZDevops/files/8310536/winequality-white.csv)

Click on **sourcedata** container and then click **Upload**.

![image](https://user-images.githubusercontent.com/19226157/159146351-eb642dbc-ae47-4da5-8b28-1f4f2f59f7e9.png)

![image](https://user-images.githubusercontent.com/19226157/159146357-faee0d2d-ee0c-4bf6-9ad3-47c0304469df.png)

Result of upload should look like this -

![image](https://user-images.githubusercontent.com/19226157/159146370-fe1a4156-ed94-4685-8bab-67dcfa9c3e77.png)


### 5.4 Setting up UAT and Prod Storage Accounts

Now that we have created our first storage account, follow the same steps ( **[5.1](#5.1-creating-the-dev-storage-account), [5.2](#5.2-add-containers-in-storage-account) and [5.3](#5.3-upload-some-csv-files)** ) to setup the UAT and PROD storage accounts in their corresponding Resource Group:
 
```
“<Initials>databricksuatsa”

“<Initials>databricksprodsa”
```


## 6. Create Dedicated Repository for Databricks

Skip to step 6.3 if you have already set up devops organization and project.

### 6.1 Creating a DevOps organization

In this section, we will be creating an Organization and Repo that will contain our Azure Databricks notebook and external jar files required to execute the notebook.

Go to the [Azure DevOps website](https://azure.microsoft.com/en-ca/services/devops/) and click on “**Sign in to Azure DevOps**” below the blue “**Start for free**” button.

![image](https://user-images.githubusercontent.com/19226157/159131162-45d9db2c-e9b1-4659-951d-86df7d941223.png)

Use the same credentials that were used to sign in to Azure.

You will be taken to a page confirming the directory. DO NOT CLICK CONTINUE. Follow the steps below based on the type of account you are currently using.

#### 6.1.1 Personal Account

If you are using a personal account for both Azure and DevOps you will need to change your directory when logging in. This will allow you to connect Azure Services to DevOps and vice versa.

Once logged in, you will see the following screen:

![image](https://user-images.githubusercontent.com/19226157/159131188-da17c82e-666d-4378-903d-27dfe1e15e96.png)

Click on “**Switch Directory**” next to your e-mail address and make sure “**Default Directory**” is selected. The directory name might be different if you have made changes to your Azure Active Directory.

![image](https://user-images.githubusercontent.com/19226157/159131213-4fe614eb-8ff6-4af1-9c10-a98c0ada9a9b.png)

Click “**Continue**”.

#### 6.1.2 Organizational Account

If you are using an Organizational account you will already be associated with a directory.

Click “**Continue**”

### 6.2 Creating Your Project

Currently, you should be on the “**Create a project to get started**” screen, you will also notice the organization name that was automatically created for you in the top left-hand corner.

Before we create our project, let’s first check and see that the DevOps organization is indeed connected to the correct Azure Active Directory.

At the bottom-left of the “**Create a project to get started**” click on “**Organization Settings**”

In the left pane select “**Azure Active Directory**” and make sure that this is the same tenant that was used when your Azure Services were created.

![image](https://user-images.githubusercontent.com/19226157/159131253-395b2f75-7d0f-4d93-ba51-99d5443f9d09.png)

Keep in mind your Directory name might be different compared to what is shown in the screenshot.

This is **not required** but now is the best time to change the organization name within DevOps as doing so, later on, could cause issues.

While staying on the “Organization Settings” page, click on “Overview”  in the left pane.

Change the name of the organization and click “**Save**”.

![image](https://user-images.githubusercontent.com/19226157/159131269-e851b24d-3970-479d-9748-e9f779fc69b1.png)

Go ahead and click on the Azure DevOps button in the top left-hand corner.

![image](https://user-images.githubusercontent.com/19226157/159131281-a6003625-5af8-4e86-a56e-c9532e77f2fe.png)

We can now start creating our project within DevOps. Our project will be named “**Azure Databricks**”

Leave the visibility as “**Private**” and select Git for “**Version control**” and Basic for “**Work item proces**s” and click on “**Create project**”

![image](https://user-images.githubusercontent.com/19226157/159131295-6925bd9c-8174-4eba-813c-6a0bcb85887d.png)

Click on “**Create project**”

We have now created an organization in DevOps as well as a project that will contain our repository for Azure Databricks. You should be loaded into your project welcome page after creating it.

![image](https://user-images.githubusercontent.com/19226157/159131309-479b1269-fcd3-435b-8472-8eff6af79afb.png)

If this is your first time using Azure DevOps, take the next few minutes to explore the options within the project. Our focus will be on the “Repos” and “Pipelines” services visible in the left menu.

### 6.3 Creating Your Repository

Click on **Repos** icon from menu and choose **+ New Repository** from repository drop down menu.

![image](https://user-images.githubusercontent.com/19226157/159146656-97597fa7-453f-4e28-81d7-049b4eb075ae.png)

Give Repository an appropriate **name** - for example - **ci-cd-databricks**, and click on **Create** to create the new repository.

Result should look something like this -

![image](https://user-images.githubusercontent.com/19226157/159146675-fc72add7-307b-4900-bc41-d375015eccbd.png)

 
## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: Complete the environment set up in UAT and PRODUCTION environment.

## :tada: Summary

This module provided helped you with necessary set up to enable to do CI / CD with databricks.


**[Next Module >](../modules/module06a.md)**
