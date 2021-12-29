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
| 4 | [Azure Repos](#4-azure-repos) | Azure Administrator |
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



## 4. Azure Repos

Azure Repos is a set of version control tools that you can use to manage your code.

Version control systems are software that help you track changes you make in your code over time. As you edit your code, you tell the version control system to take a snapshot of your files. The version control system saves that snapshot permanently so you can recall it later if you need it. Use version control to save your work and coordinate code changes across your team.

Azure Repos provides two types of version control:

- Git: distributed version control
- Team Foundation Version Control (TFVC): centralized version control

We'll use git throughout this bootcamp session. Though there are variety of IDE and tools available at your disposal but for the sake of simplicity, we'll use the DevOps portal to create the repository.

### 4a. Create a new azure repo

1. Sign in to [Azure DevOps](https://go.microsoft.com/fwlink/?LinkId=307137).

2. Choose the organization and the project.

![image](https://user-images.githubusercontent.com/19226157/147615994-1f2b33c8-af21-4b0c-bec1-799d2a4c0994.png)

3. Click on repos. On the home page, you'll find the instructions to reference the project from rest api, command line tools and IDE such as VSCode.

![image](https://user-images.githubusercontent.com/19226157/147616096-13a2097f-1b92-4d85-aa4e-7b3337c59b3e.png)

We'll choose the option to import a repository; which creates a new repository and imports the files from existing and specified repositories.

4. Select Repository type as "Git" and Clone URL - https://github.com/mkbansal0588/AZDevops.git

![image](https://user-images.githubusercontent.com/19226157/147616212-38dcc5d1-411e-4929-9f2e-2fa77c6efed6.png)

Leave the authentication required option unchecked and click on import.

![image](https://user-images.githubusercontent.com/19226157/147616240-a0a2f3eb-23f5-48c6-8e5a-aefebe9e48be.png)

5. It might take few minutes before, it creates the repository and clone the files from specified repositories. After successful import, you should be able to view the files.

![image](https://user-images.githubusercontent.com/19226157/147616297-f501c4b4-1ef5-44ac-99c1-229d1329cb2a.png)

6. Repository takes its name after the name of the project however, if you would like, you can change it afterwards.


### 4b. Branches

A branch represents an independent line of development. Branches serve as an abstraction for the edit/stage/commit process. You can think of them as a way to request a brand new working directory, staging area, and project history. 

#### How are Azure Repos' branches created?

1. View your repo's branches by selecting Repos > Branches while viewing your repo on the web.

![image](https://user-images.githubusercontent.com/19226157/147616696-7e0e84d4-7ca3-4913-bbd6-78315ca6ddc0.png)

2. Select New branch in the upper-right corner of the page.

![image](https://user-images.githubusercontent.com/19226157/147616712-bb2a9a1f-417c-4d62-88b1-2888c4d0cc8b.png)

3. In the Create a branch dialog box, enter a name for your new branch, select a branch to base the work off of, and associate any work items.

![image](https://user-images.githubusercontent.com/19226157/147616723-1428f63e-bc08-4d2b-9c32-a1717815d58d.png)

4. Select Create branch.

----------------------- ------------------------------------
## ❗ Note 

You will need to fetch the branch before you can see it and swap to it in your local repo.

----------------------------------------------------------------


## 5. Release Flow

For teams with more than one engineer, where engineers includes both developers and operations, we need to consider how we are going to allow them to collaborate on code and track changes, one of the early decisions for the team is therefore what branching methodology to use. This is particularly relevant since we should also be including Infrastructure-as-Code in our source control and will allows us to back track to see what changes were made and when to help with issue resolution.

Release Flow is a trunk-based development approach that utilizes branches off the master trunk for specific topics as opposed to other trunk-based developments that continuously deploy to the trunk. 

![image](https://user-images.githubusercontent.com/19226157/147617295-30128d0b-3f1b-4d79-8eab-48f086115cec.png)


![image](https://user-images.githubusercontent.com/19226157/147617177-249a576a-31ee-4d9e-9507-3f3af3cceb54.png)


## 6. Introduction to Azure Pipelines

## 7. Agent Pools

## :tada: Summary

This module provided an overview of how to sign up for an Azure DevOps service.

[Continue >](../modules/module02a.md)
