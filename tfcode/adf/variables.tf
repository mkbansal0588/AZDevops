variable "team_name" {
  default = "faa"
  description = "Nom "
   validation {
    condition = length(var.team_name) < 5
    error_message = "Le nom du team doit contenir au plus 4 caractères."
  }
}

variable "module_name" {
  type        = string
  description = "Name of module for which private end point is being created."
  default     = ""
}

variable "isUsingSharedIR" {
  type        = bool
  description = "Is thie ADF going to use Shared Self hosted integration runtime"
  default     = true
}


variable "isConnectionToSqlDatabaseNeeded" {
  type        = bool
  description = "Flag to determine if you need to create the SqlDatabaseConnection while creating ADF"
  default     = false
}

variable "enableShir" {
  type        = bool
  description = "Is thie ADF going to use Shared Self hosted integration runtime"
  default     = false
}

variable "enableMngdtir" {
  type        = bool
  description = "Flag to determine whether or not to enable Managed VNET Integration runtime"
  default     = false
}

variable "enableAdfmpep" {
  type        = bool
  description = "Flag to determine whether or not to enable ADF managed private endpoint"
  default     = false
}

variable "masterDataFactoryName" {
  type        = string
  description = "Name of data factory which hosted sharable self hosted integration runtime. Will only be used if isUsingSharedIR is set to true"
  default     = ""
}

variable "masterDataFactoryRGName" {
  type        = string
  description = "Name of resource group of data factory which hosted sharable self hosted integration runtime. Will only be used if isUsingSharedIR is set to true"
  default     = ""
}

variable "mastershir" {
  type        = string
  description = "Name of master self hosted integration runtime"
  default     = ""
}

variable "shir" {
  type        = string
  description = "Name of self hosted integration runtime"
  default     = ""
}

variable "mngdir" {
  type        = string
  description = "Name of managed integration runtime"
  default     = ""
}

variable "nodesize" {
  type        = string
  description = "Node size for managed integration runtime"
  default     = ""
}

variable "location_accronym"{
  type        = map
  default     = {
    "canadacentral" = "cacn"
    "canadaeast"    = "caea"
  }
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "index" {
  default = 1  
  description = "Quand on a besoin de creer une sequence de rg on utilise ce variable pour ajouter la sequence à la fin"
}

variable "counter" {
  type = number
  default = 1
  description = "Counter to add to count index to make name unique."
}

variable "public_network_enabled" {
  type        = bool
  default     = false
  description = "Nom principal de la ressource sans les prefixes ni sufixes"
}

variable "managed_virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Enabling Vnet in ADF is required to create a vnet for the managed intergration runtime"
}

variable "virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Enabling Vnet in Integration Runtime"
}

variable "client_name" {
  type        = string
  default     = "faa"
  description = "Nom principal de la ressource sans les prefixes ni sufixes"
}

variable "location" {
  type        = string
  default     = "canadacentral"
  description = "La region ou le resource groupe doit etre cree"
  validation {
    condition = var.location == "canadacentral" || var.location == "canadaeast"
    error_message = "Les seules locations valides sont: canadacentral et canadaeast."  
  }
}

variable "environment" {
  type        = string  
  default     = "de"
  description = "L'environnment"
  validation {
    condition = var.environment == "de" || var.environment == "pp" || var.environment == "pr"
    error_message = "L'environnement doivent etre choisi parmi les options : de, pp, pr."
  }
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Nom du groupe de ressources dans lequel les ressources doivent être créées"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "Id du subnet dans lequel le private endpoint doit être créé"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Les TAGS que doit faire partie des tags du resource"
}

variable "data_factory_vsts_account_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom du compte pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_branch_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom de la branche le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_project_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom du projet pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_repository_name" {
  type        = string
  default     = ""
  description = "Optionnel Nom du repo pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_root_folder" {
  type        = string
  default     = ""
  description = "Optionnel Fichier root pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
}

variable "data_factory_vsts_tenant_id" {
  type        = string
  default     = ""
  description = "Optionnel ID du tenant pour le repo Azure Data Factory. Vous devez remplir toutes les autres variables data_factory_vsts_ si vous utilisez celle-ci."
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

variable "adf_log_setting_name"{
  type        = string
  description = "Name of diagnostic setting for logs on keyvault"
  default = "log2LogAnalytics"
}

variable "adf_metric_setting_name"{
  type        = string
  description = "Name of diagnostic setting for metrics on keyvault"
  default = "metric2LogAnalytics"
}
variable "sec_subscription_id"{
  type        = string
  description = "Service partagee subscription id"
  default     = ""
}
variable "subnet_pep_id"{
  type        = string
  description = "Azure Subnet ID "
}

variable "sqldb_linkedservice_name"{
  type        = string
  description = "Linked service name"
  default     = ""
}

variable "connection_string"{
  type        = string
  description = "SQL database connnection string"
  default     = ""
}

variable "adfmpep_name"{
  type        = list(string)
  description = "ADF managed private endpoint names"
  default     = [""]
}

variable "resource_id"{
  type        = list(string)
  description = "List of resource ID of Azure services connecting to the private endpoint"
  default     = [""]
}

variable "subresource_name"{
  type        = list(string)
  description = "List of subresource name of which is connecting via ADF managed private endpoint"
  default     = [""]
}