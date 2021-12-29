variable "location_accronym"{
  type        = map
  default     = {
    "canadacentral" = "cacn"
    "canadaeast"    = "caea"
  }
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "team_name" {
  default = "devops"
  description = "team name - usually refers to line of business "
   validation {
    condition = length(var.team_name) < 5
    error_message = "Shouldn't be more than 4 characters"
  }
}

variable "client_name" {
  type        = string
  description = "client name"
  default     = "bcmp"
}

variable "index" {
  default = 1  
  description = "Resource index - helpful when creating multiple resources with same name at once."
}

variable "location" {
  type        = string
  default     = "canadacentral"
  description = "Azure Region location to use for deploying resources"
  validation {
    condition = var.location == "canadacentral" || var.location == "canadaeast"
    error_message = "Invalida Azure Region provided."  
  }
}

variable "environment" {
  type        = string  
  description = "Environment Abbreviation"
  default     = "de"
  validation {
    condition = var.environment == "de" || var.environment == "pp" || var.environment == "pr"
    error_message = "Environment Abbreviation"
  }
}

variable "extra_tags" {
  type = map
  default = null
  description = "Tags to apply on resource"
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
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

variable "enable_https_traffic_only" {
  type        = bool
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
  default     = true
}

variable "allow_blob_public_access" {
  type        = bool
  description = "Allow or disallow public access to all blobs or containers in the storage account. Defaults to false."
  default     = true
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
