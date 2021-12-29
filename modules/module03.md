## Terraform Crash Course
I’ll teach you how to get started with Terraform very quickly in this article. My main goal here is to focus on a few basic concepts of Terraform so you can install and deploy your very first Terraform script today. This is going to be straight to the point and focused on using Terraform on Windows with Azure. I will demonstrate this in the simplest of ways so that you can grasp the concepts and see this work end-to-end. Before you start, you should also create an empty folder for the workspace for this crash course.

 
## Installation
I typically create a Downloads folder and add that to my System Environment path variables. This makes it easy for me to maintain static binary tools that I download like Terraform.

https://www.terraform.io/downloads.html

### Steps
- Create Downloads\terraform folder.
- Export to Environment Variable for Paths
- [Download](https://www.terraform.io/downloads.html) and extract 64 bit Terraform binary to terraform folder.

![image](https://user-images.githubusercontent.com/19226157/147651478-d9f7c7fa-d512-4657-835a-88e4a38f2c84.png)


### Verify Installation
To verify installation you should be able to run a basic terraform command to see if Windows recognizes the bin path and finds Terraform.

```
terraform version
```

![image](https://user-images.githubusercontent.com/19226157/147651594-4f023319-883f-4d9b-b297-4eee21c8a04a.png)

 
## Azure CLI
You will need to have Azure CLI installed and working. Before you can run any of the Terraform commands below you will need to log in and set your subscription to the one you will want to use. Use the commands below to accomplish this task.

### Logging In
You’ll need to be authenticated against Azure to do any of this so make sure you run this command below.

az login --use-device-code

### List Accounts
az account list -o table

![image](https://user-images.githubusercontent.com/19226157/147651732-5db5d460-1369-45af-8965-ca0cfc9addc7.png)

### Set the Account Context
To tell Azure CLI and Terraform which Tenant and Subscription this will run against use the command below. Replace {GUID} with your Subscription ID from the output above.

az account set --subscription {GUID}

 
## Providers
Providers are simple to understand if you start with this thought, they are the gateway in which Terraform talks to a service to create infrastructure. For example, the azurerm provider allows Terraform to create infrastructure within Azure. The provider provides general settings and a library for creating Terraform scripts.

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

### Create a providers.tf file
This is the bare minimum code that is needed in the providers.tf file to tell Terraform which version of azurerm it should use to communicate with Azure.

```
providers.tf
terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>2.59.0"
        }
    }
}

provider "azurerm" {
    features {}
}
 
```
You can also add this code to main.tf file as well if you don't wishes to create a separate file.

## HashiCorp Language (HCL)

HashiCorp Language (HCL) is similar to YAML and is a declarative style with blocks, identifiers, data sources, output, variables, and can provide functionality for mapping values into the blocks.

https://www.terraform.io/docs/language/syntax/configuration.html

### Create a main.tf file

The main.tf file will be our main Terraform file for creating an Azure Kubernetes Service (AKS). This script will create a Resource Group and an Azure Kubernetes Service (AKS) instance.

You can reference the documentation in the Terraform Registry for azurerm.

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster

```
resource "azurerm_resource_group" "rg" {
  name     = "ResourceGroupK8s"
  location = "Central US"
}
 
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "AksK8s"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksdns"
 
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
 
  identity {
    type = "SystemAssigned"
  }
 
  tags = {
    Environment = var.environment
  }
}
 
output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate  
}
 
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
```

### Referencing Values from Other Blocks
If you look at the AKS block, you will see that the “location” property for “azurerm_kubernetes_cluster” is being set to location = azurerm_resource_group.rg.location. The name of the resource block is “rg” and by using the block we can get the location from that resource. This is great for keeping things consistent. For example, it’s common to pass a variable value in for the Resource Group’s location and then inherit that value throughout the script by referencing that block’s value.

### Outputs
After the script is run, outputs will put these values out into the terminal. Terraform output can also be referenced but that’s more advanced and will not be covered in this tutorial.

 
### Variables
Variables allow configuration values to be injected into the process. This is incredibly useful for deploying to multiple environments or decoupling values from the process. It’s very common to use a Continous Integration (CI) pipeline to deploy Terraform to multiple environments. In this example, we will make the Environment Tag a variable so that can be easily changed.

### Create a variables.tf file

This will create a variables.tf file with a default environment tag of “Prod”. If you were to leave out the default value then this would prompt you to enter the value before the script can be run. These are often used in CI pipelines.

```
variable "environment" {
    type = string
    description = "Dev/Test/UAT/Prod"
    default = "Prod"
}
```
 
## Terraform Commands
Now, is the fun part, we can actually deploy and destroy Terraformed infrastructure and see this work. I’m going to teach you the most basic commands that you will use to create an infrastructure through Terraform. There’s a lot more but this is the bare minimum to get started.

https://www.terraform.io/docs/cli/commands/index.html

### Init
The terraform init command will download providers and modules and prepare Terraform to be ready to plan and apply infrastructure changes.

```
terraform init
```

### Plan
Terraform plan allows you to see what changes will be applied to the infrastructure before committing to the change.

```
terraform plan
```

### Apply
The Terraform apply command applies the infrastructure changes. You will have to type “Yes” in order to commit these changes.

```
terraform apply -auto-approve
```

After typing “yes”, Terraform will being to create infrastructure. The final outcome should look like this:



### Destroy
Terraform destroy will remove all infrastructure that is in the Terraform code. So, this will remove the Azure Kubernetes Service (AKS) cluster and the resource group but if there are other resources then those will not be removed.

```
terraform destroy
```
