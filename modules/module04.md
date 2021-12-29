# Module 04 - Terraform deployment at scale

[< Previous Module](../modules/module03.md) - **[Home](../README.md)**

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
* Deploy Storage account, key vault and factory contained in a resource group.

##  :bookmark_tabs: Table of Contents

| #  | Section | Role |
| --- | --- | --- |
| 1 | [Terraform Code Review for Data Factory](#1-terraform-code-review-for-data-factory) | Azure Administrator |
| 2 | [Terraform deployment template pipeline review](#2-terraform-deployment-template-pipeline-review) | Azure Administrator |
| 3 | [Deployment variables files review](#3-deployment-variables-files-review) | Azure Administrator |
| 4 | [Deployment pipeline review](#4-deployment-pipeline-review) | Azure Administrator |

##

## 📚 Additional Reading

## 🧑‍💼 To-Do Activities

- Exercise 1: This pipeline generates the terraform plan and then applies in a single step however, in an ideal scenario, we would like to review the plan and wait for explicit approval before this plan is applied. Repurpose this pipeline to implement the desired solution. (Hint - Make use of pipeline environments)

## :tada: Summary

This module provided an overview of how to do terraform deployment at scale.
