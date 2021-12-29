terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.74.0"
    }
  }
}

provider "azurerm" {
  features {    
  }
}

locals {
create_data_factory_git_vsts_set   = var.data_factory_vsts_account_name == "" ? toset([]) : toset(["_"])
isUsingSharedIR = var.isUsingSharedIR == true ? toset(["_"]) : toset([])
index = var.enableShir ? var.index : 0
mngdtir = var.enableMngdtir ? 1 : 0
adfmpep = var.enableAdfmpep ? length(var.adfmpep_name) * var.index : 0
}

data "azurerm_client_config" "current" {}

resource "azurerm_data_factory" "adf" {
  count               = var.index
  name                = format("adf-%s-%s-%s-%s-%03d", var.team_name, var.client_name,var.environment,var.location_accronym[var.location],"${count.index + var.counter}")
  location            = var.location
  resource_group_name = var.resource_group_name
  public_network_enabled = var.public_network_enabled
  tags                = merge(local.default_tags, var.extra_tags)
  managed_virtual_network_enabled = var.managed_virtual_network_enabled 

  identity {
    type = "SystemAssigned"
  }

  dynamic "vsts_configuration" {
    for_each          = local.create_data_factory_git_vsts_set
    content {
      account_name    = var.data_factory_vsts_account_name
      branch_name     = var.data_factory_vsts_branch_name
      project_name    = var.data_factory_vsts_project_name
      repository_name = var.data_factory_vsts_repository_name
      root_folder     = var.data_factory_vsts_root_folder
      tenant_id       = var.data_factory_vsts_tenant_id
    }
  }
}
