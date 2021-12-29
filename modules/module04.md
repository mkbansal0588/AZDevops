# Module 04 - Terraform deployment at scale

[< Previous Module](../modules/module04.md) - **[Home](../README.md)**

## :thinking: Prerequisites

* An [Azure account](https://azure.microsoft.com/en-us/free/) with an active subscription.
* Your must have permissions to create resources in your Azure subscription.
* Your subscription must have the following resource providers registered: **Microsoft.DevOps**. Instructions on how to register a resource provider via the Azure Portal can be found [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal).

## :loudspeaker: Introduction

In this module, you will learn about deploying terraform deployment at scale.

## :dart: Objectives

* Create generic terraform module for azure services you are planning to deploy.
* Create terraform deployment templates.
* Create environment specific variables files for azure resource deployment.
* Create environment agnostic pipeline that make use of pipelines and variables to deploy services in multiple environments.

##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [](#1-signup-for-an-azure-devops-account) | Azure Administrator |
| 2 | [Create organization or project collection](#2-create-organization-or-project-collection) | Azure Administrator |
| 3 | [Manage your project](#3-manage-your-project) | Azure Administrator |
| 4 | [Azure Repos](#4-azure-repos) | Azure Administrator |
| 5 | [Release Flow](#5-Release-Flow) | Azure Administrator |
