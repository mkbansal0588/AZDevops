
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.59.0"
    }
  }
}

provider "azurerm" {
  storage_use_azuread = true
  features {    
  }
}

data "azurerm_client_config" "current" {}

provider "azuread" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider to be used
  version = ">1.1.0"
}

data "azurerm_resource_group" "resourceGroup" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "adls" {  
  count                     = var.index
  name                      = format("adls%s%s%s%s%s%03d", var.team_name,var.client_name,substr(var.account_name["${count.index}"], 0, 3 ), var.environment,var.location_accronym[var.location],"${count.index + var.counter}")
  resource_group_name       = var.resource_group_name
  location                  = data.azurerm_resource_group.resourceGroup.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  tags                      = merge(local.default_tags, var.extra_tags)
  is_hns_enabled            = var.is_hns_enabled
  allow_blob_public_access  = var.allow_blob_public_access
}
