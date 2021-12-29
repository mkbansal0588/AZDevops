
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

provider "azurerm" {
  subscription_id = var.sec_subscription_id 
  alias = "logAnalyticsLog"
  features {
    key_vault {
    }
  }
}


data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "logAnalyticsWorkspaceMetric" {
  name                = var.log_analytics_workspace_metric
  resource_group_name = var.log_analytics_workspace_metric_rg
}

data "azurerm_log_analytics_workspace" "logAnalyticsWorkspaceLog" {
  name                = var.log_analytics_workspace_log
  resource_group_name = var.log_analytics_workspace_log_rg
  provider            = azurerm.logAnalyticsLog
}

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

  network_rules {
    default_action             = var.default_action_enabled
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
    bypass                     = var.bypass
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  for_each           = local.data_lake_gen2_filesystem
  name               = each.value.container
  storage_account_id = azurerm_storage_account.adls[each.key].id
  
  ace {
    scope            = "access"
    type             = "group"
    id               = each.value.group
    permissions      = each.value.permission
 }
  ace {
    scope            = "default"
    type             = "group"
    id               = each.value.group
    permissions      = each.value.permission
  }
}


resource "azurerm_advanced_threat_protection" "sa" {
  count              = var.index
  target_resource_id = azurerm_storage_account.adls["${count.index}"].id
  enabled            = var.threat_protection_enabled
  depends_on = [
    azurerm_storage_account.adls
  ]
}

resource "azurerm_storage_container" "sc" {
  count = length(var.storage_containers)
  name = element(var.storage_containers,count.index).name
  container_access_type = element(var.storage_containers,count.index).container_access_type
  storage_account_name = azurerm_storage_account.adls[0].name
}

resource "azurerm_monitor_diagnostic_setting" "log" {
  count              = var.index
  name               = var.adls_log_setting_name
  target_resource_id = join("/", [azurerm_storage_account.adls["${count.index}"].id,"blobServices","default"])
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceLog.id

  log {
    category = "StorageRead"
    enabled  = true
  }
  log {
    category = "StorageWrite"
    enabled  = true
  }
  log {
    category = "StorageDelete"
    enabled  = true
  }

  depends_on = [azurerm_storage_account.adls]
}

resource "azurerm_monitor_diagnostic_setting" "metric" {
  count              = var.index
  name               = var.adls_metric_setting_name
  target_resource_id = join("/", [azurerm_storage_account.adls["${count.index}"].id,"blobServices","default"])
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceMetric.id
  
  log {
    category = "StorageRead"
    enabled  = true
  }
  log {
    category = "StorageWrite"
    enabled  = true
  }
  log {
    category = "StorageDelete"
    enabled  = true
  }
  
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
  
  depends_on = [azurerm_storage_account.adls]
}

#This should be the last action on storage account.
#resource "null_resource" "disable_key_access" {
#  count     = var.disableSASKeys ? var.index : 0
#  provisioner "local-exec" {
#    command = "if [[ ${substr(var.account_name["${count.index}"], 0, 3 )} != 'tra' ]]; then az resource update --ids ${azurerm_storage_account.adls[${count.index}].id} --set properties.allowSharedKeyAccess=false; else echo 'Skipping Transitoire storage account'; fi"
#  }
#  depends_on = [
#    azurerm_storage_account.adls
#  ]
#}

resource "null_resource" "disable_key_access" {
  count     = var.disableSASKeys ? var.index : 0

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" { 
    interpreter = ["/bin/bash" ,"-c"]
    command = "if [[ ${substr(var.account_name["${count.index}"], 0, 3 )} != ${substr(var.exempt_storage_account, 0, 3 )} ]]; then az resource update --ids ${azurerm_storage_account.adls["${count.index}"].id} --set properties.allowSharedKeyAccess=false; else az resource update --ids ${azurerm_storage_account.adls["${count.index}"].id} --set properties.allowSharedKeyAccess=true; fi"
  }
  depends_on = [
    azurerm_storage_account.adls
  ]
}

module "pep" {
  count               = var.index
  source = "./../faa-tf-module-pep/"
  client_name           = var.client_name
  environment           = var.environment
  subnet_pep_id         = var.subnet_pep_id
  module_name           = var.module_name
  index                 = "${count.index}"
  counter               = var.counter
  location              = data.azurerm_resource_group.resourceGroup.location
  resource_group_name   = var.resource_group_name
  id_resource_attache   = azurerm_storage_account.adls["${count.index}"].id
  subresource_names     = var.subresource_names
  extra_tags            =  var.extra_tags
  depends_on = [
    azurerm_storage_account.adls
#    azurerm_storage_container.sc
  ]
}
