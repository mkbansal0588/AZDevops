terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.59.0"
    }
  }
}

provider "azurerm" {
  features {    
  }
}

locals {
enable_locks = var.enable_locks ? var.index : 0
default_tags = {}
}

resource "azurerm_resource_group" "rg" {
  count    = var.index
  location = var.location
  name     = format("rg-%s-%s-%s-%s-%03d", var.team_name, var.client_name,var.environment,var.location_accronym[var.location],"${count.index + var.counter}")
  tags     = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_management_lock" "rg" {
  count      = local.enable_locks
  name       = "DenyDelete"
  scope      = azurerm_resource_group.rg["${count.index}"].id   
  lock_level = "CanNotDelete"
  notes      = "DenyDelete"
  depends_on = [
    azurerm_resource_group.rg
  ]
}
