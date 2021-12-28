# Module 01 - Azure DevOps

[< Previous Module](../modules/module00.md) - **[Home](../README.md)** - [Next Module >](../modules/module02.md)

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).

## :loudspeaker: Introduction

In this module, you will learn about Azure DevOps platform.

## :dart: Objectives

* Signup for an Azure DevOps account.
* Create Organization or project collection.
* Manage your project.
* Repositories and Branches
* Release Flow
* Introduction to Azure Pipelines
* Agent Pools

##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [Signup for an azure devops account](#1-signup-for-an-azure-devops-account) | Azure Administrator |
| 2 | [Create organization or project collection](#2-create-organization-or-project-collection) | Azure Administrator |
| 3 | [Manage your project](#3-manage-your-project) | Azure Administrator |
| 4 | [Repositories and Branches](#4-Repositories-and-Branches) | Azure Administrator |
| 5 | [Release Flow](#5-Release-Flow) | Azure Administrator |
| 6 | [Introduction to Azure Pipelines](#6-Introduction-to-Azure-Pipelines) | Azure Administrator |
| 7 | [Agent Pools](#7-Agent-Pools) | Azure Administrator |

<div align="right"><a href="#module-01---create-an-azure-purview-account">↥ back to top</a></div>

## 1. Signup for an azure devops account

1. Select the sign-up link for [Azure DevOps](https://azure.microsoft.com/services/devops/).

2. Enter your email address, phone number, or Skype ID for your Microsoft account. If you're a Visual Studio subscriber and you get Azure DevOps as a benefit, use the Microsoft account associated with your subscription. Select Next.

![image](https://user-images.githubusercontent.com/19226157/147609582-b373458f-7df2-45b3-aa58-9f9a43449cfb.png)

If you don't have a Microsoft account, choose Create one. To learn more, see create a Microsoft account.

3. Enter your password and select Sign in.

![image](https://user-images.githubusercontent.com/19226157/147609651-61781c93-4a29-4056-ae76-80f5644b8f76.png)

4. To get started with Azure DevOps, select Continue.

![image](https://user-images.githubusercontent.com/19226157/147609691-48bab3d0-c2ce-43b0-8cff-97024c2da8fc.png)

An organization is created based on the account you used to sign in. Sign in to your organization at any time, (https://dev.azure.com/{yourorganization}).

You can rename and delete your organization, or change the organization location. To learn more, see the following articles:

[Rename an organization](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/rename-organization?view=azure-devops)

[Change the location of your organization](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/rename-organization?view=azure-devops)

If you signed in with an existing Microsoft account, your next step is to Create a project. If you signed in with a newly created Microsoft account, then your project is automatically created and named after your account name. To learn more about managing projects, see Manage projects.

## 2. Create organization or project collection

Learn how to create an organization. An organization is used to connect groups of related projects, helping to scale up an enterprise. You can use a personal Microsoft account, GitHub account, or a work or school account. Use your work or school account to automatically connect your organization to your Azure Active Directory (Azure AD).

----------------------- ------------------------------------
## ❗ Note 

All organizations must be manually created via the web portal. We don't support automated creation of organizations. We do support automated organization configuration, project creation, and resource provisioning via REST API.

----------------------------------------------------------------

1. Sign in to [Azure DevOps](https://go.microsoft.com/fwlink/?LinkId=307137).

2. Select New organization.

![image](https://user-images.githubusercontent.com/19226157/147613677-e1b940b5-45d0-4dfb-af31-6bdd1e995c1f.png)

3. Confirm information, and then select Continue.

![image](https://user-images.githubusercontent.com/19226157/147613688-4038f757-59ad-4ec0-bede-57e5299a479e.png)

![image](https://user-images.githubusercontent.com/19226157/147613700-40fa96a8-dc90-49b0-80d3-79cb3c18e79f.png)


Congratulations, you're now an organization owner!

Sign in to your organization at any time, https://dev.azure.com/{yourorganization}.

## 📚 Additional Reading

Read and understand [how to Plan your organizational structure](https://docs.microsoft.com/en-us/azure/devops/user-guide/plan-your-azure-devops-org-structure?view=azure-devops).


## 3. Manage your project

### 3a. Create a project

If you signed up for Azure DevOps with a newly created Microsoft account (MSA), your project is automatically created and named based on your sign-in.

If you signed up for Azure DevOps with an existing MSA or GitHub identity, you're automatically prompted to create a project. You can create either a public or private project. To learn more about public projects, see What is a public project?.

1. Enter information into the form provided, which includes a project name, description, visibility selection, initial source control type, and work item process

![image](https://user-images.githubusercontent.com/19226157/147613942-8cf0e8f3-5fee-49ab-be19-5696adbd93f2.png)

See choosing the right version control for your project and choose a process for guidance.

2. When your project is complete, the welcome page appears.

![image](https://user-images.githubusercontent.com/19226157/147613999-0c03fd86-1546-4c7d-a386-b7650f0efd4e.png)

### 3b. Invite team members

Give team members access to your organization by adding their email addresses or GitHub usernames to your organization. For GitHub user invitations, ensure you've enabled the policy, Invite GitHub users in Organization settings > Policies tab.

1. Sign in to your organization (https://dev.azure.com/{yourorganization}).

2. Select Organization settings.

![image](https://user-images.githubusercontent.com/19226157/147614278-d41a82c2-61c1-4b91-b9d0-a2df5bdc5a3a.png)

3. Select Users > Add new users.

![image](https://user-images.githubusercontent.com/19226157/147614293-bac8b0a3-0027-4f7f-9b02-dec23285fdd3.png)

4. Enter the following information:

   - Users: Enter the email addresses (Microsoft accounts) or GitHub usernames for the users. You can add several email addresses by separating them with a semicolon (;). An email address appears in red when it's accepted.
   - Access level: Leave the access level as Basic for users who will contribute to the code base. To learn more, see About [access levels](https://docs.microsoft.com/en-us/azure/devops/organizations/security/access-levels?view=azure-devops).
   - Add to project: Select the project you want to add them to.
   - DevOps Groups: Leave as Project Contributors, the default security group for users who will contribute to your project. To learn more, see [Default permissions and access assignments](https://docs.microsoft.com/en-us/azure/devops/organizations/security/permissions-access?view=azure-devops).



## 4. Repositories and Branches

## 5. Release Flow

## 6. Introduction to Azure Pipelines

## 7. Agent Pools

## :tada: Summary

This module provided an overview of how to sign up for an Azure DevOps service.

[Continue >](../modules/module02a.md)
