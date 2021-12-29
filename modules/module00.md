# Module 00 - Lab Environment Setup

**[Home](../README.md)** - [Next Module >](../modules/module01.md)

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Owner permissions within a Resource Group to create resources and manage role assignments.
* The subscription must have the following resource providers registered.
    * Microsoft.Authorization
    * Microsoft.DataFactory
    * Microsoft.Databricks
    * Microsoft.KeyVault
    * Microsoft.Storage
* An Azure DevOps Account

## :loudspeaker: Introduction

In order to follow along with the Azure DevOps lab exercises, we need to provision a set of resources.

## :test_tube: Lab Environment Setup

### 1. Lab setup for module 1.

There is no lab set up required for module 1. All the instructions to complete module1 are provided within sections defined in module1 file.

### 2. Lab setup for module 2

#### 2a. Create a service principal

This service principal will be used by Azure DevOps Pipeline to deploy Azure services on given subscription.

There is no way to directly create a service principal using the Azure portal. When you register an application through the Azure portal, an application object and service principal are automatically created in your home directory or tenant. 

Let's jump straight into creating the identity. If you run into a problem, check the required permissions to make sure your account can create the identity.

- Sign in to your Azure Account through the Azure portal.

- Select Azure Active Directory.

- Select App registrations.

- Select New registration.

- Name the application. Select a supported account type, which determines who can use the application. Under Redirect URI, select Web for the type of application you want to create. Enter the URI where the access token is sent to. You can't create credentials for a Native application. You can't use that type for an automated application. After setting the values, select Register.

![image](https://user-images.githubusercontent.com/19226157/147629724-fcd16d82-883b-4185-8f3e-e7f300a78602.png)

You've created your Azure AD application and service principal.

#### 2b. Generate secrets for service principal

There are two types of authentication available for service principals: password-based authentication (application secret) and certificate-based authentication. We recommend using a certificate, but you can also create an application secret.

- Select Azure Active Directory.

- From App registrations in Azure AD, select your application.

- Select Certificates & secrets.

- Select Client secrets -> New client secret.

- Provide a description of the secret, and a duration. When done, select Add.After saving the client secret, the value of the client secret is displayed. Copy this value because you won't be able to retrieve the key later. You will provide the key value with the application ID to sign in as the application. Store the key value where your application can retrieve it.

![image](https://user-images.githubusercontent.com/19226157/147633112-4d4e7174-2ddf-4772-9257-4f8d8c4da454.png)


#### 2c. Get tenant and app ID values for signing in

When programmatically signing in, pass the tenant ID with your authentication request and the application ID. You also need a certificate or an authentication key (described in the following section). To get those values, use the following steps:

- Select Azure Active Directory.

- From App registrations in Azure AD, select your application.

- Copy the Directory (tenant) ID and store it in your application code.

![image](https://user-images.githubusercontent.com/19226157/147633274-dd7e9927-de2c-46ba-8882-8cab5e64e31d.png)

- Copy the Application ID and store it in your application code.

![image](https://user-images.githubusercontent.com/19226157/147633339-c2119e0c-75e6-42b6-b137-71d5bcbc1a69.png)


#### 2d. Assign role to service principal on subscription

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

![image](https://user-images.githubusercontent.com/19226157/147633508-ef5f3576-33a6-4565-befa-34ec9a0ccdd3.png)


#### 2e. Create a Azure DevOps service connection

Complete the following steps to create a service connection for Azure Pipelines.

- Sign in to your organization (https://dev.azure.com/{yourorganization}) and select your project.

- Select Project settings > Service connections.

![image](https://user-images.githubusercontent.com/19226157/147630261-5d5b04f0-68a1-4461-8d7f-178083fb4fbd.png)

- Select + New service connection, select the type of service connection as "Azure Resource Manager", and then select Next.

![image](https://user-images.githubusercontent.com/19226157/147630324-7dc509c7-2320-4d85-8229-21e97296c4f8.png)

- Choose recommended authentication method, i.e. Service principal (Manual), and then select Next.

![image](https://user-images.githubusercontent.com/19226157/147633574-89d26232-3ad6-4ea7-b6df-88184fc75f7f.png)

- Enter the following details:
  - Scope Level: Subscription
  - Subscription ID: Search for subscription, click on subscription and click on Overview.

![image](https://user-images.githubusercontent.com/19226157/147633870-fea895d6-6b35-4428-8d09-60dd7f7cda79.png)

  - Subscription Name

![image](https://user-images.githubusercontent.com/19226157/147633792-93b10e7d-28df-4db4-bccb-67be88a0ecd5.png)

  - Service Principal ID: Client ID collected in Lab setup step 2c.
  - Credential: Service Principal Key.
  - Service Principal Key: Secret generated and collected in Lan setup setp 2b.
  - Tenant Id: Tenant ID collected in Lab setup step 2c.
  - Service Connection Name
  - Check the security box allowing permissions to all pipeline.

![image](https://user-images.githubusercontent.com/19226157/147634133-7cb7f465-3f80-48d7-bafc-1ba750961880.png)

Verify and save the connection details.

![image](https://user-images.githubusercontent.com/19226157/147634209-31e9a21f-51e7-48d2-89f6-d96e3c838dcb.png)

#### 2e. Create a blob storage account for storing terraform state file.

To create an Azure storage account with the Azure portal, follow these steps:

- From the left portal menu, select Storage accounts to display a list of your storage accounts.

- On the Storage accounts page, select Create.

- Options for your new storage account are organized into tabs in the Create a storage account page. Fill in the following details in basic tab.
  - Subsciption 
  - Resource Group: Create New.
  - Name: Give it a unique name
  - Region: Canada Central

- Leave rest of the option default and click on Review and Create.

![image](https://user-images.githubusercontent.com/19226157/147634771-6e862151-07bc-48b4-a285-c1c4bc132e92.png

- Next, click on Containers in Data Storage section and then click on "+ Container" 

![image](https://user-images.githubusercontent.com/19226157/147634869-6a1d8858-833f-447d-9340-db912b6d7a12.png)

- Let's name the container "statefiles" and disable anonymous access. 

![image](https://user-images.githubusercontent.com/19226157/147634942-4c63b2d5-713d-429a-9549-fa5ff0b2e289.png)

Click on Create to create the container.

![image](https://user-images.githubusercontent.com/19226157/147635173-5c9abf34-c4e2-4529-a429-106a27793ff4.png)

That should complete the step 2e.

#### 2f. Create a key vault for storing secrets.

- From the Azure portal menu, or from the Home page, select Create a resource.

- In the Search box, enter Key Vault.From the results list, choose Key Vault.

- On the Key Vault section, choose Create.

- On the Create key vault section provide the following information:
  - Name: A unique name is required. For this quickstart, I've used exampleapp12292021
  - Subscription: Choose a subscription.
  - Under Resource Group, choose the resource group created in Step 2e.
  - In the Location pull-down menu, choose "Canada Central".
  - In next tab, access-policy tab, Click on "+ Add Access Policy". Choose "Key, Secret, & Certificate Management" template and Choose the Service Principal created in Step 2a.

![image](https://user-images.githubusercontent.com/19226157/147635506-62b04100-965f-4535-b98c-31a4afad94e1.png)

Click on Add to add the access policy.

- After providing the information above, select Create.

Take note of the two properties listed below:

- Vault Name: In the example, this is exampleapp12292021. You will use this name for other steps.
- Vault URI: In the example, this is https://exampleapp12292021.vault.azure.net/. Applications that use your vault through its REST API must use this URI.

At this point, your Azure account and Service principal is the only one authorized to perform operations on this new vault.

#### 2g. Add secrets to key vault.

- Look up the recently created keyvault. Click on "Secrets" option in setting.

- Click on "+Generate/Import" to add new secrets to key vault.

![image](https://user-images.githubusercontent.com/19226157/147635750-edc4e807-aff9-4fd4-9be7-4b1906f709b3.png)

- Add the following four secrets one after another.
  - Upload Options: Manual
  - Name: clientid
  - value: Value of client ID collected in Lab setup step 2c.
  - Click Add to add the secret.

![image](https://user-images.githubusercontent.com/19226157/147635970-371b8841-6f7d-4efb-b6c7-4afaee58e3bb.png)

  - Upload Options: Manual
  - Name: clientsecret
  - value: Value of secret generated and collected in Lab setup step 2b.
  - Click Add to add the secret.

  - Upload Options: Manual
  - Name: tenantid
  - value: Value of tenant ID collected in Lab setup step 2c.
  - Click Add to add the secret.

  - Upload Options: Manual
  - Name: subscriptionid
  - value: Value of client ID collected in Lab setup step 2c.
  - Click Add to add the secret.

----------------------- ------------------------------------
## ❗ Note 

It is imperative that you use the same name of secrets as mentioned here since these names are used in pipelines. Changing the names could have an implication in executing the pipelines created in current and subsequent module.

----------------------------------------------------------------

here is how it should look like after you've added all required secrets to key vault.

![image](https://user-images.githubusercontent.com/19226157/147636181-903a28d1-28aa-4f90-a25a-01b8d02f85cb.png)

#### 2h. Set Up Billing for Azure DevOps for running pipeline.

- Login to DevOps portal.

- Click on Project Settings and then click on Parallel jobs under pipeline.

![image](https://user-images.githubusercontent.com/19226157/147638514-8b61b6bd-26ad-498d-9b7f-fee1a48a3ebd.png)

- Currently there the number of parallel jobs purchased to be run in Microsoft hosted agents is 0 for both private and public project.

- In private project section, Under Microsoft hosted, click on Change to review and update monthly purchased parallel job runs.

![image](https://user-images.githubusercontent.com/19226157/147638750-017631e9-f311-4bbf-b5de-ebcaebdd81bd.png)

- This should redirect you to, Billing section on Organization Settings page.

![image](https://user-images.githubusercontent.com/19226157/147638848-4c5e3092-f414-46f8-9727-fdd691185a84.png)

- Click on Set Up Billing and connect the Devops to subscription. 

![image](https://user-images.githubusercontent.com/19226157/147638910-d83853c7-8f3d-4dc1-9340-e3a6ed6061cd.png)

- Click on Save to finish the linking.

- After that is done, you should be able to purchase the parallel pipeline's run.

![image](https://user-images.githubusercontent.com/19226157/147639011-7ccfd8b5-ef0e-43a6-a102-034b660f9382.png)

- Set the Microsoft hosted paid parallel job to 1 and then save the changes.

This mark the completion of Lab setup step 2h.


#### 2i - Create a Pipeline execution environment.

Pipeline execution environment is mandatory part of job schema. Pipeline execution environment enable you with additional options to enforce additional checks and approvals during pipeline execution. Follow the steps to create a pipeline execution environment.

- Login to Azure Devops portal.

- Choose the right organization and project if you have multiple organizations and projects.

- Click on Environments, under Pipelines.

![image](https://user-images.githubusercontent.com/19226157/147650272-f4138738-ccb0-4370-b265-68a887204ffa.png)

- Click on New Environment to create one. Give this environment a name and leave all other options default. Click create a new environment.

![image](https://user-images.githubusercontent.com/19226157/147650374-418b0b12-fdb4-4d32-a6ba-d73a5754a6dd.png)

- After this environment is created, you can associate additional checks and approvals with this environment.

![image](https://user-images.githubusercontent.com/19226157/147650450-be619352-60e5-4fe6-a3e3-893cb312d531.png)

- Below screenshot contains, list of few checks that you can associate with an environment.

![image](https://user-images.githubusercontent.com/19226157/147650535-1d1a2e6b-89d9-4b17-8048-3ef94edad260.png)






