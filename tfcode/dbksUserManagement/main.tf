terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.59.0"
    }
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.5"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "=1.6.0"
    }
  }
}


data "databricks_group" "group_name" {
    count        = var.haveSpToAddToDBGroups ? 1 : 0  
    display_name = var.group_display_name
}

resource "databricks_service_principal" "sp" {
  count             = var.haveSpToSyncWithWorkspace ? 1 : 0
  application_id    = var.sp_application_id
  display_name      = var.sp_display_name
}

resource "databricks_group_member" "vip_member" {
    count     = var.haveSpToAddToDBGroups && var.haveSpToSyncWithWorkspace ? 1 : 0
    group_id  = data.databricks_group.group_name[count.index].id
    member_id = databricks_service_principal.sp[count.index].id
}