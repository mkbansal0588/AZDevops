variable "team_name" {
  default = "faa"
  description = "Nom "
   validation {
    condition = length(var.team_name) < 5
    error_message = "Le nom du team doit contenir au plus 4 caractères."
  }
}

variable "client_name" {
  type        = string
  description = "Nom principal de la ressource sans les prefixes ni sufixes."
  default     = ""
}

variable "exempt_storage_account" {
  type        = string
  description = "Name of the storage account which is exempt from disabling Access keys"
  default     = "transitoire"
}

variable "module_name" {
  type        = string
  description = "Name of module for which private end point is being created."
  default     = ""
}

variable "account_name_accronym"{
  type        = map
  default     = {
    "transitoire"   = "tra"
    "brute"    = "bru"
    "noarmalisee" = "nor"
    "consommation" = "con"
    "exploration" = "exp"
  }
  description = "Name of the storage accounts and their acronym."
}

variable "account_name" {
  type        = list(string)
  description = "List of names of storage accounts"
  default     = []
}

variable "is_hns_enabled" {
  type        = bool
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created."
  default     = true
}

variable "disableSASKeys" {
  type        = bool
  description = "Flag to determine whether or not disable SAS for storage account. Mainly used for AzureML deployment."
  default     = true
}


variable "threat_protection_enabled" {
  type        = bool
  description = "Nom principal de la ressource sans les prefixes ni sufixes."
  default     = true
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
  default     = true
}

variable "allow_blob_public_access" {
  type        = bool
  description = "Allow or disallow public access to all blobs or containers in the storage account. Defaults to false."
  default     = false
}

variable "bypass" {
  type        = list(string)
  description = "Default action for services to bypass"
  default     = ["AzureServices"]
}


variable "default_action_enabled" {
  type        = string
  description = "Default action for network ACL."
  default     = "Deny"
}

variable "min_tls_version" {
  type        = string
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_0 for new storage accounts."
  default     = "TLS1_2"
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group which will contain this storage account"

}

variable "index" {
  default = 1  
  description = "Quand on a besoin de creer une sequence de rg on utilise ce variable pour ajouter la sequence à la fin"
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
  description = "L'environnment "
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

variable "extra_tags" {
  type = map
  default = {}
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "(Optional) Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. Changing this forces a new resource to be created. Defaults to `StorageV2`."
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "(Optional) Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. For `FileStorage` accounts only `Premium` is valid. Changing this forces a new resource to be created. Defaults to `Standard`."
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "(Optional) Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS` and `ZRS`. Defaults to `LRS`."
}

variable "ip_rules" {
  type        = list(string)
  description = "IPs du proxy Desjardis que sont permis de consulter l"
  default     = []
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "(Optional) List of Azure Subnet IDs having access to the storage account. Default value is the LC's Concourse worker subnet ID."

  default = []
}

variable "subnet_pep_id"{
  type        = string
  description = "Azure Subnet ID "
  }

variable "log_analytics_workspace_log"{
  type        = string
  description = "Log Analytics Workspace logs"
}

variable "log_analytics_workspace_metric"{
  type        = string
  description = "Log Analytics Workspace for metric"
}

variable "log_analytics_workspace_log_rg"{
  type        = string
  description = "Resource Group for Log Analytics workspace for storing Log "
}

variable "log_analytics_workspace_metric_rg"{
  type        = string
  description = "Resource Group for Log Analytics workspace for storing metrics "
}

variable "adls_log_setting_name"{
  type        = string
  description = "Name of diagnostic setting for logs on adls"
  default = "log2LogAnalytics"
}

variable "adls_metric_setting_name"{
  type        = string
  description = "Name of diagnostic setting for metrics on adls"
  default = "metric2LogAnalytics"
}

variable "storage_containers" {  
  default = []

  description = <<DESCRIPTION
    (Optional) List of storage container definition. Attribute `name` and `container_access_type` are reserved. Any other Key/Value pairs will end up in `metadata` attribute.

    name:                  (Required) The name of the Container which should be created within the Storage Account.
    container_access_type: (Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private.

  DESCRIPTION
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}

variable "sec_subscription_id"{
  type        = string
  description = "Service partagee subscription id"
}

variable "subresource_names" {
  type = list(string)
  default = ["dfs"]
  description = "subresource name for private end point"
}