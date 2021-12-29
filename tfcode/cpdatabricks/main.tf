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

provider "azurerm" {
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = data.azurerm_databricks_workspace.wsdatabricks.id
}

data "azurerm_databricks_workspace" "wsdatabricks" {
    name = var.workspace_name
    resource_group_name = var.resource_group_name
}

data "azurerm_client_config" "current" {
}

resource "databricks_group" "group" {
  count        = length(var.groupList)
  display_name = var.groupList["${count.index}"].display_name
  allow_cluster_create = var.groupList["${count.index}"].allow_cluster_create
  allow_instance_pool_create = var.groupList["${count.index}"].allow_instance_pool_create
  #workspace_access = var.groupList["${count.index}"].workspace_access
  allow_sql_analytics_access = var.groupList["${count.index}"].allow_sql_analytics_access
}

module "user_management" {
  count                 = var.haveSpToSyncWithWorkspace ? length(var.spList) : 0
  source                = "./../faa-tf-module-dbksUserManagement/"
  haveSpToAddToDBGroups = var.spList["${count.index}"].haveSpToAddToDBGroups
  haveSpToSyncWithWorkspace = var.haveSpToSyncWithWorkspace
  group_display_name = var.spList["${count.index}"].group_display_name
  sp_display_name = var.spList["${count.index}"].sp_display_name
  sp_application_id = var.spList["${count.index}"].sp_application_id
  depends_on =[
    databricks_group.group
  ]
}

resource "databricks_workspace_conf" "custom_config" {
    custom_config = {
        "enableIpAccessLists": var.enableIpAccessLists
        #"enableTokensConfig": true
    #    "enforceClusterViewAcls": false
    #    "enableJobViewAcls": false
    #    "enableAclsConfig": true
    #    "enableHlsRuntime": false
    #    "enableDcs": true
    #    "enable-X-Frame-Options": true
    #    "enable-X-Content-Type-Options": true
    #    "enable-X-XSS-Protection": true
    #    "enableResultDownloading": true
    #    "enableUploadDataUis": true
    #    "enableExportNotebook": true
    #    "enableNotebookGitVersioning": false
    #    "enableNotebookTableClipboard": true
    #    "enableWebTerminal": true
    #    "enablebfsFileBrowser": true
    #    "enableDatabricksAutologgingAdminConf": true
    #    "mlflowRunArtifactDownloadEnabled": true
    #    "mlflowModelServingEndpointCreationEnabled": true
    #    "mlflowModelRegistryEmailNotificationsEnabled": true
    #    "enableProjectTypeInWorkspace": false
    #    "rStudioUserDefaultHomeBase": "/User/dbj3754@mvtdesjardins.com"
    #    "storeInteractiveNotebookResultsInCustomerAccount": false
    #    "enableTableAclsConfig": false
    #    "enableClusterAclsConfig": true
    #    "enableWorkspaceAclsConfig": true
    }
    depends_on = [
      databricks_cluster_policy.clusterPolicy, 
      databricks_instance_pool.instance_pools 
    ]
}

resource "databricks_ip_access_list" "allowed-list" {
  count = length(var.ip_access_list) == 0 ? 0 : 1
  label = var.label
  list_type = var.list_type
  ip_addresses = var.ip_access_list
  depends_on = [databricks_workspace_conf.custom_config]
}

resource "databricks_cluster_policy" "clusterPolicy" {
    count = length(var.clusterPolicyList)
    name = var.clusterPolicyList["${count.index}"].name
    #definition = jsonencode(file("./DataEngineer.policy"))
    #definition = local.json_data
    definition = file(format("%s%s", var.clusterPolicyList["${count.index}"].loc, var.clusterPolicyList["${count.index}"].definition))
    depends_on = [
      databricks_group.group
    ]
}

resource "databricks_permissions" "clusterPolicyPermissions" {
    count = length(var.clusterPolicyList)
    cluster_policy_id = databricks_cluster_policy.clusterPolicy["${count.index}"].id
    access_control {
      group_name       = var.clusterPolicyList["${count.index}"].group_name
      permission_level = var.clusterPolicyList["${count.index}"].permission_level
    }
    depends_on = [
      databricks_cluster_policy.clusterPolicy
    ]
}


resource "databricks_instance_pool" "instance_pools" {
  count              = length(var.instancePoolList)
  instance_pool_name = var.instancePoolList["${count.index}"].instance_pool_name
  min_idle_instances = var.instancePoolList["${count.index}"].min_idle_instances
  max_capacity       = var.instancePoolList["${count.index}"].max_capacity
  node_type_id       = var.instancePoolList["${count.index}"].node_type_id
  azure_attributes {
    availability = var.instancePoolList["${count.index}"].availability
    spot_bid_max_price = var.instancePoolList["${count.index}"].spot_bid_max_price
  }
  idle_instance_autotermination_minutes = var.instancePoolList["${count.index}"].idle_instance_autotermination_minutes
  disk_spec {
    disk_type {
      azure_disk_volume_type = var.instancePoolList["${count.index}"].azure_disk_volume_type
    }
    disk_size = var.instancePoolList["${count.index}"].disk_size
    disk_count = var.instancePoolList["${count.index}"].disk_count
  }
  depends_on = [
      databricks_group.group
    ]
}

resource "databricks_permissions" "instance_pools_permissions" {
    count = length(var.instancePoolList)
    instance_pool_id = databricks_instance_pool.instance_pools["${count.index}"].id

    access_control {
        group_name = var.instancePoolList["${count.index}"].group_name
        permission_level = var.instancePoolList["${count.index}"].permission_level
    }
    depends_on = [
      databricks_instance_pool.instance_pools
    ]
}

resource "databricks_global_init_script" "init1" {
  count = length(var.initScriptList)
  source = var.initScriptList["${count.index}"].source
  name = var.initScriptList["${count.index}"].name
  enabled = var.initScriptList["${count.index}"].enabled
}

#resource "databricks_dbfs_file" "this" {
#  source = "./removeJndiClass.sh"
#  path = "/databricks/init/removeJndiClass.sh"
#}

# Currently not possible because of cloud provider limitation.
#resource "databricks_secret_scope" "secretScopeKV" {
#  count = length(var.secretScopeList)
#  name = var.secretScopeList["${count.index}"].name
#
#  keyvault_metadata {
#    resource_id = var.secretScopeList["${count.index}"].resource_id
#    dns_name = var.secretScopeList["${count.index}"].dns_name
#  }
#}

resource "databricks_secret_acl" "secret_acls" {
    count = length(var.secretScopeList)
    principal = var.secretScopeList["${count.index}"].principal
    permission = var.secretScopeList["${count.index}"].permission
    scope = var.secretScopeList["${count.index}"].name
    depends_on = [
      #databricks_secret_scope.secretScopeKV,
      databricks_group.group
    ]
}
