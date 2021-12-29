variable "resource_group_name" {
  type        = string  
  description = "The name of a resource"
   validation {
    condition = var.resource_group_name != ""
    error_message = "Le nom du resource group est obligatoire."  
  }
}

variable "team_name" {
  type        = string  
  description = "The name of the team"
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

variable "sku"{
  type        = string
  description = "Niveau de service"
  default = "premium"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Les TAGS que doit faire partie des tags du resource"
}

variable "ip_access_list" {
  type        = list(string)
  default     = []
  description = "IPs authorized to reach the workspace"
}


variable "sec_subscription_id"{
  type        = string
  description = "Service partagee subscription id"
  default     = ""
}

variable "subscription_id"{
  type        = string
  description = "Primary subscription id"
  default     = ""
}

variable "log_analytics_workspace_log"{
  type        = string
  description = "Log Analytics Workspace logs"
  default = "npd01-cacn-log-cguards01"
}

variable "log_analytics_workspace_log_rg"{
  type        = string
  description = "Resource Group for Log Analytics workspace for storing Log "
  default = "npd01-rgp-logging01"
}

variable "log_analytics_workspace_metric"{
  type        = string
  description = "Log Analytics Workspace for metrics"
}

variable "log_analytics_workspace_metric_rg"{
  type        = string
  description = "Resource Group for Log Analytics workspace for storing metrics "
}

variable "private_subnet_name"{
  type        = string
  description = "Name of the subnet"
  default     = ""
}

variable "public_subnet_name"{
  type        = string
  description = "Name of the subnet"
  default     = ""
}

variable "vnet_name"{
  type        = string
  description = "Name of the subnet"
  default     = ""
}

variable "vnet_resource_group_name"{
  type        = string
  description = "Name of the subnet"
  default     = ""
}

variable "public_network_access_enabled"{
  type        = bool
  description = "(Optional) Allow public access for accessing workspace. Set value to false to access workspace only via private link endpoint. Possible values include true or false. Defaults to true. Changing this forces a new resource to be created."
  default     = false
}

variable "network_security_group_rules_required"{
  type        = string
  description = "(Optional) Does the data plane (clusters) to control plane communication happen over private link endpoint only or publicly? Possible values AllRules, NoAzureDatabricksRules or NoAzureServiceRules. Required when public_network_access_enabled is set to false. Changing this forces a new resource to be created."
  default     = "AllRules"
}

variable "no_public_ip"{
  type        = bool
  description = "(Optional) Are public IP Addresses not allowed? Possible values are true or false. Defaults to false. Changing this forces a new resource to be created."
  default     = true
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}

variable "index" {
  default = 1
  description = "Quand on a besoin de creer une sequence de rg on utilise ce variable pour ajouter la sequence à la fin"
}

variable "module_name" {
  type        = string
  description = "Name of module for which private end point is being created."
  default     = "adb"
}

variable "subnet_pep_id"{
  type        = string
  description = "Azure Subnet ID "
  }

variable "subresource_names" {
  type = list(string)
  default = ["databricks_ui_api"]
  description = "subresource name for private end point"
}

variable "databricks_log_setting_name"{
  type        = string
  description = "Name of diagnostic setting for logs on adls"
  default = "log2LogAnalytics5"
}

variable "databricks_metric_setting_name"{
  type        = string
  description = "Name of diagnostic setting for metrics on adls"
  default = "metric2LogAnalytics5"
}
