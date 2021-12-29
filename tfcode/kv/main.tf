provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
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

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_key_vault" "keyVault" {
  count                       = var.index
  name                        = format("kv-%s-%s-%s-%s-%03d", var.team_name, var.client_name,var.environment,var.location_accronym[var.location],"${count.index + var.counter}")
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  enable_rbac_authorization   = var.enable_rbac_authorization
  network_acls {
    bypass = var.network_acls_bypass
    default_action = var.network_acls_default_action
    ip_rules = var.network_acls_ip_rules
    virtual_network_subnet_ids = var.network_acls_virtual_network_subnet_ids
  }
 
  sku_name = var.sku_name
  tags                        = merge(local.default_tags, var.extra_tags)
}

module "pep" {
  count                 = var.index
  environment           = var.environment
  source                = "./../faa-tf-module-pep/"
  client_name           = var.client_name
  module_name           = var.module_name
  index                 = "${count.index}"
  counter               = var.counter
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  id_resource_attache   = azurerm_key_vault.keyVault["${count.index}"].id
  subresource_names     = ["vault"]
  subnet_pep_id         = var.subnet_pep_id
  extra_tags            = var.extra_tags
  depends_on = [
    azurerm_key_vault.keyVault
  ]
}

resource "azurerm_monitor_diagnostic_setting" "log" {
  count              = var.index
  name               = var.keyVault_log_setting_name
  target_resource_id = azurerm_key_vault.keyVault["${count.index}"].id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceLog.id

  log {
    category = "AuditEvent"
    enabled  = true
  }
  depends_on = [
    azurerm_key_vault.keyVault
  ]
}

resource "azurerm_monitor_diagnostic_setting" "metric" {
  count              = var.index
  name               = var.keyVault_metric_setting_name
  target_resource_id = azurerm_key_vault.keyVault["${count.index}"].id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logAnalyticsWorkspaceMetric.id
  
  metric {
    category = "AllMetrics"
    enabled  = true
  }

  log {
    category = "AuditEvent"
    enabled  = true
  }

  log {
    category = "AuditPolicyEvaluationDetails"
    enabled  = true
  }
  
  depends_on = [
    azurerm_key_vault.keyVault
  ]
}