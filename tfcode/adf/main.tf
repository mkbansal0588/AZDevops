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


data "azurerm_data_factory" "masterDataFactory" {
  count               = var.isUsingSharedIR ? 1 : 0
  name                = var.masterDataFactoryName
  resource_group_name = var.masterDataFactoryRGName
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

resource "azurerm_data_factory_linked_service_azure_sql_database" "adf_sqldb_ls" {
  count               = var.isConnectionToSqlDatabaseNeeded ? var.index : 0
  name                = format("%s-%s", var.sqldb_linkedservice_name, "${count.index + var.counter}")
  resource_group_name = var.resource_group_name
  data_factory_name   = azurerm_data_factory.adf[count.index].name
  connection_string   = var.connection_string
  
  depends_on = [

    azurerm_data_factory.adf

  ]
}

resource "azurerm_monitor_diagnostic_setting" "log" {
  count              = var.index
  name               = var.adf_log_setting_name
  target_resource_id = azurerm_data_factory.adf["${count.index}"].id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceLog.id

  log {
    category = "ActivityRuns"
    enabled  = true
  }
  log {
    category = "PipelineRuns"
    enabled  = true
  }
  log {
    category = "TriggerRuns"
    enabled  = true
  }
  log {
    category = "SandboxPipelineRuns"
    enabled  = true
  }
  log {
    category = "SandboxActivityRuns"
    enabled  = true
  }
  log {
    category = "SSISPackageEventMessages"
    enabled  = true
  }
  log {
    category = "SSISPackageExecutableStatistics"
    enabled  = true
  }
  log {
    category = "SSISPackageEventMessageContext"
    enabled  = true
  }
  log {
    category = "SSISPackageExecutionComponentPhases"
    enabled  = true
  }
  log {
    category = "SSISPackageExecutionDataStatistics"
    enabled  = true
  }
  log {
    category = "SSISIntegrationRuntimeLogs"
    enabled  = true
  }
  
  depends_on = [
    azurerm_data_factory.adf
  ]
}

resource "azurerm_monitor_diagnostic_setting" "metric" {
  count              = var.index
  name               = var.adf_metric_setting_name
  target_resource_id = azurerm_data_factory.adf["${count.index}"].id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceMetric.id
  
  metric {
    category = "AllMetrics"
    enabled  = true
  }

  log {
    category = "ActivityRuns"
    enabled  = true
  }
  log {
    category = "PipelineRuns"
    enabled  = true
  }
  log {
    category = "TriggerRuns"
    enabled  = true
  }
  log {
    category = "SandboxPipelineRuns"
    enabled  = true
  }
  log {
    category = "SandboxActivityRuns"
    enabled  = true
  }
  log {
    category = "SSISPackageEventMessages"
    enabled  = true
  }
  log {
    category = "SSISPackageExecutableStatistics"
    enabled  = true
  }
  log {
    category = "SSISPackageEventMessageContext"
    enabled  = true
  }
  log {
    category = "SSISPackageExecutionComponentPhases"
    enabled  = true
  }
  log {
    category = "SSISPackageExecutionDataStatistics"
    enabled  = true
  }
  log {
    category = "SSISIntegrationRuntimeLogs"
    enabled  = true
  }
  
  depends_on = [
    azurerm_data_factory.adf
  ]
}

module "pep" {
  count                 = var.index
  environment           = var.environment
  subnet_pep_id         = var.subnet_pep_id
  source                = "./../faa-tf-module-pep/"
  client_name           = var.client_name
  module_name           = var.module_name
  index                 = "${count.index}"
  counter               = var.counter
  location              = var.location
  resource_group_name   = var.resource_group_name
  id_resource_attache   = azurerm_data_factory.adf["${count.index}"].id
  subresource_names     =  ["dataFactory"]
  extra_tags            =  var.extra_tags
  depends_on = [
    azurerm_data_factory.adf
  ]
}

module "pep2" {
  count                 = var.index
  environment           = var.environment
  subnet_pep_id         = var.subnet_pep_id
  source                = "./../faa-tf-module-pep/"
  client_name           = var.client_name
  module_name           = format("%s-%s", var.module_name,"portal")
  index                 = "${count.index}"
  counter               = var.counter
  location              = var.location
  resource_group_name   = var.resource_group_name
  id_resource_attache   = azurerm_data_factory.adf["${count.index}"].id
  subresource_names     =  ["portal"]
  extra_tags            =  var.extra_tags
  depends_on = [
    azurerm_data_factory.adf
  ]
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "shir" {
  count               = local.index
  name                = var.shir
  resource_group_name = var.resource_group_name
  data_factory_name   = format("adf-%s-%s-%s-%s-%03d", var.team_name, var.client_name,var.environment,var.location_accronym[var.location],"${count.index + var.counter}")
  dynamic "rbac_authorization" {
    for_each = local.isUsingSharedIR
    content {
      resource_id = join("/", [data.azurerm_data_factory.masterDataFactory["${count.index}"].id, "integrationruntimes", var.mastershir ])
    }
  }
  depends_on = [
    azurerm_data_factory.adf
  ]
}

resource "azurerm_data_factory_integration_runtime_azure" "mngdtir" {
  count               = local.mngdtir
  name                = var.mngdir
  data_factory_name   = azurerm_data_factory.adf[count.index].name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_enabled  = var.virtual_network_enabled

  depends_on = [
    azurerm_data_factory.adf
  ]
}

resource "azurerm_data_factory_managed_private_endpoint" "adfmpep" {
  count              = local.adfmpep
  name               = var.adfmpep_name[count.index % length(var.adfmpep_name)]
  data_factory_id    = azurerm_data_factory.adf[count.index % var.index].id
  target_resource_id = var.resource_id[count.index % length(var.adfmpep_name)]
  subresource_name   = var.subresource_name[count.index % length(var.adfmpep_name)]

  depends_on = [
    azurerm_data_factory.adf
  ]
}