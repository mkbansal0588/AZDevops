# Module 05 - CI/CD with Data Factory

[< Previous Module](../modules/module04.md) - **[Home](../README.md)** - [Next Module >](../modules/module05a.md)

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).
* 

## :loudspeaker: Introduction

In this module, you will learn about CI/CD process with Data Factory

## :dart: Objectives

* Create two Data Factory instances.
* Create a dedicated repository for Data Factory templates.
* Connect one of the data factory instance with Azure DevOps.
* Build a data copy pipeline and publish the templates.
* Create a devops pipeline to propagate the templates from one data factory to another.

##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [Objective](#1-objective) | NA |
| 2 | [Create Data Factory Instances](#2-create-data-factory-instances) | Azure Administrator |
| 3 | [Create Dedicated Repository for Data Factory](#3-create-dedicated-repository-for-data-factory) | Azure Administrator |
| 4 | [Configure Data Factory Connectivity to Azure DevOps](#4-configure-data-factory-connectivity-to-azure-devops) | Azure Administrator |
| 5 | [Build Data Copy Pipeline and publish the templates](#5-build-data-copy-pipeline-and-publish-the-templates) | Azure Administrator |
| 6 | [Create DevOps Pipeline to propagate templates from one data factory to another](#6-create-devops-pipeline-to-propagate-templates-from-one-data-factory-to-another) | Azure Administrator |

## 1. Objective

Objective of this module to build a data copy pipeline in Development data factory; and move this pipeline to other data factory designated as production data factory.

The diagram below is a simple example of an Azure Data Factory pipeline. In this example, we want to move a single CSV file from blob storage into anotehr storage account. This activity is done through an Azure Data Factory (ADF) pipeline. ADF pipelines consist of several parts and typically consist of linked services, datasets, and activities.

![image](https://user-images.githubusercontent.com/19226157/159130336-e6dcd37c-9b4a-47b1-aa22-1eabc6ec7ddd.png)

## 2. Create Data Factory Instances

There are several things to consider before starting. You will need access to an Azure Subscription with the ability to create resource groups as well as resources with the “Owner” role assignment. Without the “Owner” privileges, you will not be able to create a service principal that provides DevOps access to your Data Factories within your Resource groups.

### Step 1: Setting up the Azure environment

We will start by creating three resource groups as well as three data factories. Each pair will resemble one of the three environments. This can be done through the Azure Portal. Keep in mind, Resource Group names have to be unique in your subscription, whereas Data Factories must be unique across Azure.

For this walkthrough, we will follow the following naming scheme for our resources:

```
<Your Initials>-<Project>-<Environment>-<Resource>

```



#### 1.1 Creating Resource Groups

With the naming scheme in mind, we will create three Resource Groups with the following names (do not forget to use your initials):

```
“<Initials>-warehouse-dev-rg”  

“<Initials>-warehouse-uat-rg”

“<Initials>-warehouse-prod-rg”
 
 ```

##### 1.1.1 Creating the DEV Resource Group

Once logged into Azure, on top of the home page click on “**Create a resource**”

create a resource

Using the search bar, search for “**Resource Group**” and select “**Resource Group**” from the search results.

Once in the “**Resource Group**” resource information page, click “**Create**”.

On the “**Create a resource group**” page there will be three fields that need to be filled out:

**Subscription** – Choose your subscription from the list

**Resource Group** – {initials}-warehouse-dev-rg
 
**Region** – Select the Region that is most appropriate to your current location.

The result should look something like this:
 
![image](https://user-images.githubusercontent.com/19226157/159130672-972c624f-51a2-4c06-9cf3-198c01060371.png)

create a resource group
 
Click on “**Review + Create**”.

You should see a green bar on the top of the page that says, “Validation passed”.

Click “**Create**” at the bottom of the page.


##### 1.1.2 Creating the UAT and PROD Resource Groups
 
Now that we have created our first resource group, follow the same steps to create the UAT and PROD Resource Groups:

```
“<Initials>-warehouse-uat-rg”

“<Initials>-warehouse-prod-rg”
```

Once you have created all three Resource Groups, you should see them in your azure portal:

![image](https://user-images.githubusercontent.com/19226157/159130819-c714fc92-91f7-45bd-8e6f-0f7377199d48.png)


#### 1.2 Creating Azure Data Factories

Now we will start creating the necessary Data Factories in each respective Resource Group that we created.

With the naming scheme in mind, we will create three Data Factories with the following names (do not forget to use your initials):

```
“<Initials>-warehouse-dev-df”

“<Initials>-warehouse-uat-df”

“<Initials>-warehouse-prod-df”
```

***Important*** Since Azure Data Factory names must be unique across all of Azure, you might need to add a random number(s) to the end of your initials for it to be unique. This will not cause any issues going forward.

##### 1.2.1 Creating the DEV Data Factory

On top of the Azure home page click on “**Create a resource**”

![image](https://user-images.githubusercontent.com/19226157/159130912-e8f48916-b7fc-4cae-9e06-1d6d29c579c9.png)


Using the search bar, search for “Data Factory” and select “**Data Factory**” from the search results.

Once in the “**Data Factory**” resource information page, click “**Create**”.

On the “**Create Data Factory**” page there will be five fields that need to be filled out:

**Subscription** – Choose your subscription from the list

**Resource Group** – Select “**{Initials}-warehouse-dev-rg**” from the drop-down menu.

**Region** – Select the Region that is most appropriate to your current location.

**Name** - {Initials}-warehouse-dev-df

**Version** -V2

The result should look something like this:

![image](https://user-images.githubusercontent.com/19226157/159130933-096bb4b4-3930-4fe2-8bde-ada3314c338b.png)


At the bottom of the page click on “**Next: Git configuration >**”

With regards to the Git configuration, it is something we will be setting up later. Make sure the “**Configure Git Later**” checkbox is checked off.

Click on “**Review + Create**”.

You should see a green bar on the top of the page that says, “**Validation passed**”.

Click “**Create**” at the bottom of the page.

##### 1.2.2 Creating UAT and PROD Data Factories

Now that we have created our first Data Factory, follow the same steps to create the UAT and PROD Data Factories in their corresponding Resource Group:

```
“<Initials>-warehouse-uat-df”

“<Initials>-warehouse-prod-df”
```

Once completed, you will be able to see one Data Factory in each Resource Group. The environment of the Data Factory should be identical to that of the Resource Group.

## 3. Create Dedicated Repository for Data Factory

### 3.1 Creating a DevOps organization

In this section, we will be creating an Organization and Repo that will contain our Azure Data Factory code and our pipelines.

Go to the [Azure DevOps website](https://azure.microsoft.com/en-ca/services/devops/) and click on “**Sign in to Azure DevOps**” below the blue “**Start for free**” button.

![image](https://user-images.githubusercontent.com/19226157/159131162-45d9db2c-e9b1-4659-951d-86df7d941223.png)

Use the same credentials that were used to sign in to Azure.

You will be taken to a page confirming the directory. DO NOT CLICK CONTINUE. Follow the steps below based on the type of account you are currently using.

#### 3.1.1 Personal Account

If you are using a personal account for both Azure and DevOps you will need to change your directory when logging in. This will allow you to connect Azure Services to DevOps and vice versa.

Once logged in, you will see the following screen:

![image](https://user-images.githubusercontent.com/19226157/159131188-da17c82e-666d-4378-903d-27dfe1e15e96.png)

Click on “**Switch Directory**” next to your e-mail address and make sure “**Default Directory**” is selected. The directory name might be different if you have made changes to your Azure Active Directory.

![image](https://user-images.githubusercontent.com/19226157/159131213-4fe614eb-8ff6-4af1-9c10-a98c0ada9a9b.png)

Click “**Continue**”.

#### 3.1.2 Organizational Account

If you are using an Organizational account you will already be associated with a directory.

Click “**Continue**”

### 3.2 Creating Your Project

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

We can now start creating our project within DevOps. Our project will be named “**Azure Data Factory**”

Leave the visibility as “**Private**” and select Git for “**Version control**” and Basic for “**Work item proces**s” and click on “**Create project**”

![image](https://user-images.githubusercontent.com/19226157/159131295-6925bd9c-8174-4eba-813c-6a0bcb85887d.png)

Click on “**Create project**”

We have now created an organization in DevOps as well as a project that will contain our repository for Azure Data Factory. You should be loaded into your project welcome page after creating it.

![image](https://user-images.githubusercontent.com/19226157/159131309-479b1269-fcd3-435b-8472-8eff6af79afb.png)

If this is your first time using Azure DevOps, take the next few minutes to explore the options within the project. Our focus will be on the “Repos” and “Pipelines” services visible in the left menu.

## 4. Configure Data Factory Connectivity to Azure DevOps	 

### 4.1 Link Dev Data Factory to DevOps Repo

Our next step is to connect our DEV Data Factory to the repository we have just created. This will be the only Data Factory that will be added to the repository. It will be the DevOps release pipeline’s duty to push that code into UAT and PROD.

In the Azure portal go to your **DEV Resource Group** and click on your **DEV Data Factory**, then click “**Author & Monitor**”.

On the DEV Data Factory home page, click on “**Set up code repository**”

![image](https://user-images.githubusercontent.com/19226157/159131330-9d4d1a7c-2fb6-4e0f-9493-3bbbc263351d.png)

There will be several options for getting the DEV Data Factory connected to the repository.

Once the “**Configure a repository**” pane opens, select the appropriate values in the settings:

<ol>
  <li>Repository Type – Azure DevOps Git</li>
  <li>Azure Active Directory – Select your Azure Active Directory from the list</li>
  <li>Azure DevOps Account – Select the organization name that was created during the “Creating an Azure DevOps organization and repo” step.</li>
  <li>Project Name – Azure Data Factory</li>
  <li>Repository name – Select “Use existing”, from the drop-down select Azure Data Factory</li>
  <li>Collaboration branch – master</li>
  <li>Publish branch – adf_publish</li>
  <li>Root folder – Leave it as the default “/”</li>
  <li>Import existing resource – Since this Data Factory is new and contains nothing in it, we will not be selecting “Import existing resources to repository”</li>
</ol>
 
Your values for certain fields will be different, but this is what you should expect:

![image](https://user-images.githubusercontent.com/19226157/159131498-7cc8022f-4006-452e-b4d2-0e7a92072109.png)

Click “**Apply**”.

Now, let us check to make sure that our Data Factory is indeed connected to our repository.

On the left-hand side click on the pencil “**Author**”. If you get prompted to Select working branch, make sure you have “**Use Existing**” and “**master**” selected and click **Save** at the bottom.  


![image](https://user-images.githubusercontent.com/19226157/159131514-bbcecc6b-724c-45a4-8ae4-4ae6ab53f743.png)


## 5. Build Data Copy Pipeline and publish the templates

### 5.1 Create a linked service

First step in creating a test pipeline is creating the linked service in data factory.

On the “**Manage**” page, click on Linked Services under Connections. Click on **New** to add a new Linked Services. Linked Services is the place, where you define the source and destination sources.
 
![image](https://user-images.githubusercontent.com/19226157/159131759-04fb00f3-d2c2-41ec-ae04-b413c251c83e.png)

Search for **Gen2** in Data Store. Click on **Azure Data Lake Storage Gen2** Icon and **Continue**.

![image](https://user-images.githubusercontent.com/19226157/159131772-b8f852b5-3984-4a31-b5a6-d4eca1ea4d1b.png)
 
On the next page, fill out the following details –

<ul>
  <li>Name – Connection Name, Let’s call it Source.</li>
  <li>Description – Optional</li>
  <li>Connect via integration runtime – AutoResolveIntegrationRuntime; should be auto-populated.</li>
  <li>Authentication method – Account key</li>
  <li>Account selection method – From Azure Subscription</li>
	 <li>Azure Subscription – Choose the appropriate subscription</li>
	 <li>Storage account name – Choose the storage account</li> 
 <li>Test Connection - To linked service</li>
</ul>

![image](https://user-images.githubusercontent.com/19226157/159131881-34e8dd67-06dd-47ea-bbdd-4431f4db78d0.png)
 
Click on **Test Connection** and make sure, connectivity works before clicking on Create button which will create the link service.

When you click on Create, a publish message will be displayed. It means, this service will be written to git.

![image](https://user-images.githubusercontent.com/19226157/159131901-b12e4110-dd16-4806-9f88-2a4543d491f8.png)

![image](https://user-images.githubusercontent.com/19226157/159131913-4986293d-defe-40e5-bffa-e6e2dcbffb02.png)

### 5.2 Source DataSet

Next step in the process is to create the data move pipeline. Let’s head over to data factory studio. In the studio, click on **pencil** icon, to start creating the pipeline.

![image](https://user-images.githubusercontent.com/19226157/159131932-ff7beda9-d641-434c-8a4a-11f2fc1a0d72.png) 


First step in creating the data factory pipeline, is to create a data set. Click on **+** icon and then click on **Dataset**.

![image](https://user-images.githubusercontent.com/19226157/159131944-2c506b9f-29f0-4428-b26e-ec2a9127cd82.png)

Search for **Gen2** in search box, click on **Azure Data Lake Storage Gen2** icon when appeared and click on **continue**.

![image](https://user-images.githubusercontent.com/19226157/159131956-c6f8ecb4-5b54-42f0-a871-3708804034f1.png)
 

Choose **binary**, irrespective of the type of files that you have uploaded to storage account and click **continue**.

![image](https://user-images.githubusercontent.com/19226157/159131966-9370ac8f-d0c2-4fa6-9591-f48982f1555e.png)
 

On the next page, fill out the following details –

<ul>
  <li>Name – Optional, but let’s change it to sourcedataset</li>
  <li>Linked service – Choose the linked service created in step #1. You should be able to find it in drop down menu.</li>
  <li>File Path – Data Factory has embedded storage account explorer option however, you can manually type the following details as well.</li>
    <ul>   
      <li>File system – sourcedata</li>
 </ul>
</ul>

Click **OK** to save the dataset.

![image](https://user-images.githubusercontent.com/19226157/159132083-62893a99-19ed-48e9-968f-02f499298e48.png)
  

Click on **Save all**  to save the dataset details.

![image](https://user-images.githubusercontent.com/19226157/159132095-2de965f5-e2eb-4126-a3e1-98b9c061b08c.png)

### 5.3 Target DataSet

Follow the same steps to create target dataset with one change, **Name** of the dataset should be **targetdataset**  and File path should be **destinationdata**.

![image](https://user-images.githubusercontent.com/19226157/159132107-ce004389-26a9-4890-bc70-ac58dd1ca521.png)


### 5.4 Data Move Pipeline

In the final step of the process, we’ll be creating the data move pipeline. 

Click on **+** Icon and click on **pipeline**.

![image](https://user-images.githubusercontent.com/19226157/159132158-606be334-6d43-4a51-abd3-be58d343cf18.png)


When you choose Pipeline option, a designer page to build the pipeline should open up. From, list of **activities**, choose **copy data** from **Move & Transform section**.

![image](https://user-images.githubusercontent.com/19226157/159132185-d3557a89-d872-4472-9583-3c833876480b.png)
 
Give this pipeline a meaningful **name** and **Properties** Icon on top right-hand side of the page to close this pane.

![image](https://user-images.githubusercontent.com/19226157/159132206-2ad0ef6b-6a6b-420c-92a8-afe2f3c0db7f.png)


Now drag, the **copy data** activity to canvass and let’s start designing the data move pipeline.

![image](https://user-images.githubusercontent.com/19226157/159132222-4217dcf2-13ee-4e48-beac-7c42af610a8c.png)


If you click on, **Copy data1** activity, it will highlight the missing details that are required to completed the configuration.

![image](https://user-images.githubusercontent.com/19226157/159132235-74691091-4b98-4811-98c4-94b721801342.png)
 

For **Source and Sink**, choose the **source and sink** dataset named **sourcedataset, targetdataset** respectively and leave rest of the details as default.


![image](https://user-images.githubusercontent.com/19226157/159132261-32b311d6-aa89-4f95-a179-1c6302beab82.png)

![image](https://user-images.githubusercontent.com/19226157/159132273-074ef3a2-2fa1-4e64-89b6-ccbf1afb5e47.png)


Next click on **Save** to save the pipeline details.

![image](https://user-images.githubusercontent.com/19226157/159132276-4e5ad668-132e-4c1f-b743-f08d47a59ca3.png)
 

***Important** It is recommended to use “**Validate all**” to verify the set up and identify the issues if any.

![image](https://user-images.githubusercontent.com/19226157/159132294-c073d661-7fcc-4347-b3b3-39116dae2c53.png)


If there aren’t any issue, you should receive a successful validation message.

![image](https://user-images.githubusercontent.com/19226157/159132302-21a34352-136b-4947-94fe-3149e2c08689.png)
 

Next, let’s debug the pipeline to make sure that it is working as expected.

![image](https://user-images.githubusercontent.com/19226157/159132317-705ac91d-8d00-4bbf-846f-b8aea7cf4bb0.png)
 
 
Debug will trigger the pipeline and you should be able to monitor the debug pipeline progress on same page.

![image](https://user-images.githubusercontent.com/19226157/159132332-b1f00986-c3e2-4839-949b-5e8897d05bdd.png)


Alternatively, you can also check the destinationdata container in storage account.  You should see all the files that you have uploaded to sourcedata folder.

![image](https://user-images.githubusercontent.com/19226157/159132343-28361cde-af0b-4018-9b77-101a391873dc.png)
 

### 5.4 Generate Pipeline templates

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



## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: Make changes to pre-production and production terraform module for some/all the modules and deploy two additional sets of resource groups.

## :tada: Summary

This module provided an overview of how to do terraform deployment at scale.
