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
  }
}

provider "azurerm" {
  subscription_id   = var.subscription_id
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

data "azurerm_resource_group" "resourceGroup" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                 = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_subnet" "private_subnet" {
  name                 = var.private_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

resource "azurerm_databricks_workspace" "wsdatabricks" {
  name                           = format("wsdbricks-%s-%s-%s-%s", var.team_name, var.client_name, var.environment, var.location_accronym[var.location])
  resource_group_name            = data.azurerm_resource_group.resourceGroup.name
  location                       = data.azurerm_resource_group.resourceGroup.location
  sku                            = var.sku
  #public_network_access_enabled  = var.public_network_access_enabled
  #network_security_group_rules_required = AllRules
  tags                           = merge(local.default_tags, var.extra_tags)

  custom_parameters {
    no_public_ip        = var.no_public_ip
    public_subnet_name  = data.azurerm_subnet.public_subnet.name
    private_subnet_name = data.azurerm_subnet.private_subnet.name
    virtual_network_id  = data.azurerm_virtual_network.vnet.id 
  }
}

#module "pep" {
#  count                 = var.index
#  source                = "./../faa-tf-module-pep/"
#  client_name           = var.client_name
#  environment           = var.environment
#  subnet_pep_id         = data.azurerm_subnet.private_subnet.id
#  module_name           = var.module_name
#  index                 = "${count.index}"
#  counter               = var.counter
#  location              = data.azurerm_resource_group.resourceGroup.location
#  resource_group_name   = var.resource_group_name
#  id_resource_attache   = azurerm_databricks_workspace.wsdatabricks.id
#  subresource_names     = var.subresource_names
#  extra_tags            =  var.extra_tags
#  depends_on = [
#    azurerm_databricks_workspace.wsdatabricks
#  ]
#}

resource "azurerm_monitor_diagnostic_setting" "log" {
  name                       = var.databricks_log_setting_name
  target_resource_id         = azurerm_databricks_workspace.wsdatabricks.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceLog.id

  log {
    category = "dbfs"
    enabled  = true
  }
  log {
    category = "clusters"
    enabled  = true
  }
  log {
    category = "accounts"
    enabled  = true
  }
  log {
    category = "jobs"
    enabled  = true
  }
  log {
    category = "notebook"
    enabled  = true
  }
  log {
    category = "ssh"
    enabled  = true
  }
  log {
    category = "workspace"
    enabled  = true
  }
  log {
    category = "secrets"
    enabled  = true
  }
  log {
    category = "sqlPermissions"
    enabled  = true
  }
  log {
    category = "instancePools"
    enabled  = true
  }
  log {
    category = "sqlanalytics"
    enabled  = true
  }
  log {
    category = "genie"
    enabled  = true
  }
  log {
    category = "globalInitScripts"
    enabled  = true
  }
  log {
    category = "iamRole"
    enabled  = true
  }
  log {
    category = "mlflowExperiment"
    enabled  = true
  }
  log {
    category = "featureStore"
    enabled  = true
  }
  log {
    category = "RemoteHistoryService"
    enabled  = true
  }
  log {
    category = "mlflowAcledArtifact"
    enabled  = true
  }
  
  depends_on = [
    azurerm_databricks_workspace.wsdatabricks
  ]
}

resource "azurerm_monitor_diagnostic_setting" "metric" {
  name               = var.databricks_metric_setting_name
  target_resource_id = azurerm_databricks_workspace.wsdatabricks.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceMetric.id
  
  log {
    category = "dbfs"
    enabled  = true
  }
  log {
    category = "clusters"
    enabled  = true
  }
  log {
    category = "accounts"
    enabled  = true
  }
  log {
    category = "jobs"
    enabled  = true
  }
  log {
    category = "notebook"
    enabled  = true
  }
  log {
    category = "ssh"
    enabled  = true
  }
  log {
    category = "workspace"
    enabled  = true
  }
  log {
    category = "secrets"
    enabled  = true
  }
  log {
    category = "sqlPermissions"
    enabled  = true
  }
  log {
    category = "instancePools"
    enabled  = true
  }
  log {
    category = "sqlanalytics"
    enabled  = true
  }
  log {
    category = "genie"
    enabled  = true
  }
  log {
    category = "globalInitScripts"
    enabled  = true
  }
  log {
    category = "iamRole"
    enabled  = true
  }
  log {
    category = "mlflowExperiment"
    enabled  = true
  }
  log {
    category = "featureStore"
    enabled  = true
  }
  log {
    category = "RemoteHistoryService"
    enabled  = true
  }
  log {
    category = "mlflowAcledArtifact"
    enabled  = true
  }
  
  depends_on = [
    azurerm_databricks_workspace.wsdatabricks
  ]
}