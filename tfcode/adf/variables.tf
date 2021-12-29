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

variable "index" {
  default = 1  
  description = "Resource index - helpful when creating multiple resources with same name at once."
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}

variable "public_network_enabled" {
  type        = bool
  default     = true
  description = "Nom principal de la ressource sans les prefixes ni sufixes"
}

variable "managed_virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Enabling Vnet in ADF is required to create a vnet for the managed intergration runtime"
}

variable "client_name" {
  type        = string
  description = "client name"
  default     = "bcmp"
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

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group to use for deploying this resource"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags, other than the common tags"
}

variable "data_factory_vsts_account_name" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Organization Name"
}

variable "data_factory_vsts_branch_name" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Collaboration Branch Name"
}

variable "data_factory_vsts_project_name" {
  type        = string
  default     = ""
  description = "Data Factory Git - Project Name"
}

variable "data_factory_vsts_repository_name" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Repository Name"
}

variable "data_factory_vsts_root_folder" {
  type        = string
  default     = "/"
  description = "(Optional)Data Factory Git - Root folder in the repository. Defaults to /"
}

variable "data_factory_vsts_tenant_id" {
  type        = string
  default     = ""
  description = "(Optional)Data Factory Git - Tenant ID"
}
