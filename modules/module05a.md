# Module 05a - CI/CD with Data Factory - Pipeline Deployment

[< Previous Module](../modules/module05.md) - **[Home](../README.md)** - [Next Module >](../modules/module05b.md)

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).
* [< Previous Module](../modules/module05.md)

## :loudspeaker: Introduction

In this module, you will learn about creation Data Factory Pipeline.

## :dart: Objectives

* What is Integration Runtime?
* Create a linked service.
* Create Data Factory datasets.
* Create a pipeline.


##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [Integration Runtime](#1-integration-runtime) | Azure Administrator |
| 2 | [Linked Service](#2-linked-service) | Azure Administrator |
| 3 | [Datasets](#3-datasets) | Azure Administrator |
| 4 | [Data Factory Pipeline](#4-data-factory-pipeline) | Azure Administrator |


## 1. Integration Runtime

An Integration Runtime (IR) is the compute infrastructure used by Azure Data Factory to provide data integration capabilities such as Data Flows and Data Movement. It has access to resources in either public networks, or hybrid scenarios (public and private networks).

Integration Runtimes are specified in each Linked Service, under Connections.

![image](https://user-images.githubusercontent.com/19226157/159144541-4d4feeb8-90ef-47a5-b88f-484692e56fbd.png)

There are 3 types to choose from.

![image](https://user-images.githubusercontent.com/19226157/159144550-101f3111-ea90-4a6b-bf76-58af3893f462.png)

**Azure Integration Runtime** is managed by Microsoft. All the patching, scaling and maintenance of the underlying infrastructure is taken care of. The IR can only access data stores and services in public networks.

**Self-hosted Integration Runtimes** use infrastructure and hardware managed by you. You’ll need to address all the patching, scaling and maintenance. The IR can access resources in both public and private networks.

**Azure-SSIS Integration Runtimes** are VMs running the SSIS engine which allow you to natively execute SSIS packages. They are managed by Microsoft. As a result, all the patching, scaling and maintenance is taken care of. The IR can access resources in both public and private networks.

### 1.1 Integration Runtime Scenarios

![image](https://user-images.githubusercontent.com/19226157/159144568-bf9c03ed-1554-474f-b8fe-978995cc7142.png)

<ul>
  <li>Azure automatically provisions an integration Runtime which can connect to Azure resources (Azure SQL, Azure Synapse Analytics, Storage Accounts) without any issues.</li>
  <li>You can perform data integration securely in a private network environment, shielded from the public cloud environment. For that you need to install a self-hosted IR inside your virtual private network. The self-hosted integration runtime only makes outbound HTTP-based connections to open internet.</li>
  <li>You can also perform data integration securely in an on prem environment. For that you need to install a Self-hosted IR behind your corporate firewall in your on prem environment.</li>
  <li>You can natively execute SSIS Packages by creating an Azure-SSIS Integration Runtime which creates an Integration Services Catalog in Azure SQL Database where the packages are stored. An ADF pipeline run sends commands to the Azure SSIS IR which executes the SSIS Packages.</li>
</ul>

## 2 Linked Service

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

## 3. Datasets

### 3.1 Source DataSet

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

### 3.2 Target DataSet

Follow the same steps to create target dataset with one change, **Name** of the dataset should be **targetdataset**  and File path should be **destinationdata**.

![image](https://user-images.githubusercontent.com/19226157/159132107-ce004389-26a9-4890-bc70-ac58dd1ca521.png)


## 4. Data Factory Pipeline

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
 

## 📚 Additional Reading

<ul>
	<li>https://docs.microsoft.com/en-us/azure/data-factory/data-factory-tutorials</li>
</ul>

## 🧑‍💼 To-Do Activities

- Exercise 1: Add wrapper to this pipeline to run this pipeline in a loop
   - Hint: Use "for-each" activity.

## :tada: Summary

This module provided an overview of how to do terraform deployment at scale.


**[Next Module >](../modules/module05b.md)**
