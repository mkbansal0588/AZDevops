variable "workspace_name" {
  type        = string  
  description = "The name of the workspace"
  validation {
    condition = var.workspace_name != ""
    error_message = "Le nom du workspace est obligatoire."  
  }
}

variable "resource_group_name" {
  type        = string  
  description = "The name of a resource group containing databricks workspace."
  validation {
    condition = var.resource_group_name != ""
    error_message = "Le nom du resource group est obligatoire."  
  }
}

variable "team_name" {
  type        = string  
  description = "The name of the team"
  default     = "faa"
}

variable "client_name" {
  type        = string  
  description = "The name of the team"
}

variable "location" {
  type        = string
  default     = "canadacentral"
  description = "La region ou le resource groupe doit etre cree"
  validation {
    condition = var.location == "canadacentral" || var.location == "canadaeast"
    error_message = "Les seules locations valides sont canadacentral et canadaeast."  
  }
}

variable "environment" {
  type        = string  
  description = "code environnment"
  default     = "de"
  validation {
    condition = var.environment == "de" || var.environment == "pp" || var.environment == "pr"
    error_message = "Lenvironnement doivent etre choisi parmi les options  de, pp et pr."
  }
}

variable "location_accronym"{
  type        = map
  default     = {
    "canadacentral" = "cacn"
    "canadaeast"    = "caea"
  }
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "label" {
  type        = string
  description = "(Optional) This is the display name for the given IP ACL List."
  default = "allow_in"
}

variable "list_type" {
  type        = string
  description = "Can only be ALLOW or BLOCK"
  default = "ALLOW"
}

variable "enableIpAccessLists" {
  type        = bool
  description = "Specify whether or not to enable Ip access list for databricks workspace. It is always recommended to turn in on."
  default = true
}

variable "ip_access_list" {
  type        = list(string)
  description = "(Required) (String) The node type for the instances in the pool. All clusters attached to the pool inherit this node type and the pool’s idle instances are allocated based on this type. You can retrieve a list of available node types by using the List Node Types API call."
}

##############################################

variable "groupList" {
  type = list(object({
    display_name = string,
    allow_cluster_create = bool,
    allow_instance_pool_create = bool,
    workspace_access = bool,
    allow_sql_analytics_access = bool
  }))
  description = "Group List object to add groups to workspace."
}


#################################################

variable "haveSpToSyncWithWorkspace" {
  type        = bool
  description = "Specify whether or not there are SP's present that required to be sync with Databricks workspace."
  default = true
}

variable "spList" {
  type = list(object({
    sp_display_name = string,
    sp_application_id = string,
    group_display_name = string,
    haveSpToAddToDBGroups = bool
  }))
  description = "Service List object to add service principal to workspace."
}

####################################################

variable "clusterPolicyList" {
  type = list(object({
    name = string,
    loc = string,
    definition = string,
    group_name = string,
    permission_level = string
  }))
  description = "Cluster Policy List object to add various cluster policies to workspace."
}
/*
#### CLuster policy permission level- Old variable no longer being used 
variable "cluster_policy_permission_level" {
  type        = string
  description = "Permission to grant on cluster policy"
  default = "CAN_USE"
}
*/

###################################################

variable "instancePoolList" {
  type = list(object({
    instance_pool_name = string,
    min_idle_instances = number,
    max_capacity = number,
    node_type_id = string,
    availability = string,
    spot_bid_max_price = string,
    idle_instance_autotermination_minutes = number,
    azure_disk_volume_type = string,
    disk_size = number,
    disk_count = number,
    group_name = string,
    permission_level = string
  }))
  description = "Instance pool List object to add various instance pools to workspace."
}

/*
#---------------------------variables unique to instance pool/ NOT BEING USED ONLY HERE TO EXPLAIN KEY VAULE PAIRS IN OBJECT DEFINITION OF INSTANCE POOLS -------------------------------------------------------------#

variable "availability" {
  type        = string
  description = "Availability type used for all subsequent nodes past the first_on_demand ones. Valid values are SPOT_AZURE, SPOT_WITH_FALLBACK_AZURE, and ON_DEMAND_AZURE. Note: If first_on_demand is zero, this availability type will be used for the entire cluster."
  validation {
    condition = var.availability == "SPOT_AZURE" || var.availability == "SPOT_WITH_FALLBACK_AZURE" || var.availability == "ON_DEMAND_AZURE"
    error_message = "Unknown Availability type."  
  }
  default = "SPOT_AZURE"
}

variable "spot_bid_max_price" {
  type        = number
  description = "The max price for Azure spot instances. Use -1 to specify lowest price."
  default = -1
}


variable "instance_pool_names" {
  type        = list(string)
  description =  "(Required) list(String) The name of the instance pool. This is required for create and edit operations. It must be unique, non-empty, and less than 100 characters"
  default = []
}

variable "min_idle_instances" {
  type        = list(number)
  description = "(Optional) list(Integer) The minimum number of idle instances maintained by the pool. This is in addition to any instances in use by active clusters"
  default = []
}


variable "max_capacity" {
  type        = list(number)
  description =  "(Optional) list(Integer) The maximum number of instances the pool can contain, including both idle instances and ones in use by clusters. Once the maximum capacity is reached, you cannot create new clusters from the pool and existing clusters cannot autoscale up until some instances are made idle in the pool via cluster termination or down-scaling."
  default = []
}

variable "node_type_ids" {
  type        = list(string)
  description = "(Required)list(String) The node type for the instances in the pool. All clusters attached to the pool inherit this node type and the pool’s idle instances are allocated based on this type. You can retrieve a list of available node types by using the List Node Types API call."
  default = []
}


variable "idle_instance_autotermination_minutes" {
  type        = number
  description =  "(Required) (Integer) The number of minutes that idle instances in excess of the min_idle_instances are maintained by the pool before being terminated. If not specified, excess idle instances are terminated automatically after a default timeout period. If specified, the time must be between 0 and 10000 minutes. If you specify 0, excess idle instances are removed as soon as possible."
  default     = 30
}

variable "azure_disk_volume_types" {
  type        = list(string)
  description = "(Optional) (String) The type of Azure disk to use. Options are: PREMIUM_LRS (Premium storage tier, backed by SSDs) or STANDARD_LRS (Standard storage tier, backed by HDDs)"
  #validation {
  #  count = length(var.azure_disk_volume_types)
  #  condition = var.azure_disk_volume_types["${count.index}"] != "PREMIUM_LRS" || var.azure_disk_volume_types["${count.index}"] != "STANDARD_LRS"
  #  error_message = "Unknown azure disk volume type."  
  #}
  default = []
}

variable "disk_counts" {
  type        = list(number)
  description =  "(Optional) (Integer) The number of disks to attach to each instance. This feature is only enabled for supported node types. Users can choose up to the limit of the disks supported by the node type. For node types with no local disk, at least one disk needs to be specified."
  default = []
}

variable "disk_sizes" {
  type        = list(number)
  description = "(Optional) (Integer) The size of each disk (in GiB) to attach"
  #validation {
  #  count = length(var.disk_sizes)
  #  condition = var.disk_sizes["${count.index}"] > 1023 || var.disk_sizes["${count.index}"] < 1
  #  error_message = "Unknown azure disk size."  
  #}
  default = []
}

variable "instance_pool_permission_level" {
  type        = string
  description = "Permission to grant on instance pool"
  default = "CAN_ATTACH_TO"
}

############################# END OF CLUSTER POLICY VARIABLES ################################
*/

variable "secretScopeList" {
  type = list(object({
    name = string,
    resource_id = string,
    dns_name = string,
    principal = string,
    permission = string
  }))
  description = "Secret scope List object to add KV backed secret scope to workspace and grant permission to groups"
}

variable "initScriptList" {
  type = list(object({
    source = string,
    name = string,
    enabled = bool
  }))
  description = "Init script List object"
}