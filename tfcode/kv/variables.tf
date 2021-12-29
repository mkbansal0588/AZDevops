
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
  default     = "dgag"
}

variable "module_name" {
  type        = string
  description = "Name of module for which private end point is being created."
  default     = ""
}


variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created."
  default     = "rg-vault-faa-dev-01"
}

variable "index" {
  default     = 1  
  description = "Quand on a besoin de creer une sequence de rg on utilise ce variable pour ajouter la sequence à la fin"
  type        = number
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
  default = {
    "Test Yanick"         = "Test Yanick"
  }
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = true
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys"
}

#variable "deployment_type" {
#  type        = string
#  default     = "vm"
#  description = "This variables will decide whether or not to enabled disk encryption flag in the deployment. Added after discusion with Steeve Roy"
#}

#variable "use_cases" {
#  type        = list(string)
#  default     = ["development", "vm", "keyvault"]
#  description = "Use cases types that dictate whether or not to enable disk encryption. Added after discusion with Steeve Roy"
#}

variable "soft_delete_retention_days" {
  type        = number
  default     = 30
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days"
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to false."
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = false
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false."
}


variable "sku_name"{
  type        = string
  default     = "standard"
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium"
}

variable "network_acls_bypass" {
  type        = string
  default     = "AzureServices"
  description = "(Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
}

variable "network_acls_default_action" {
  type        = string
  default     = "Deny"
  description = " (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
}

variable "network_acls_ip_rules" {
  type        = list(string)
  default     = []
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to false."
}

variable "network_acls_virtual_network_subnet_ids" {
  type        = list(string)
  default     = [
    "/subscriptions/97a2fbd5-0d85-419e-ae2c-99f6605b9b06/resourceGroups/lacdonnees-cacn-nprod-net-rg01/providers/Microsoft.Network/virtualNetworks/lacdonnees-cacn-nprod-vnet01/subnets/DEV_FAA_PEP"    
  ]
  description = "(Optional) One or more Subnet ID's which should be able to access this Key Vault."
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

variable "keyVault_log_setting_name"{
  type        = string
  description = "Name of diagnostic setting for logs on keyvault"
  default = "log2LogAnalytics"
}

variable "keyVault_metric_setting_name"{
  type        = string
  description = "Name of diagnostic setting for metrics on keyvault"
  default = "metric2LogAnalytics"
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}
variable "sec_subscription_id"{
  type        = string
  description = "Service partagee subscription id"
  default     = ""
}
variable "subnet_pep_id"{
  type        = string
  description = "Subnet private endpoint id"
  default     = ""
}