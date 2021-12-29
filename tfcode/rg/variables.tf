variable "location_accronym"{
  type        = map
  default     = {
    "canadacentral" = "cacn"
    "canadaeast"    = "caea"
  }
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "team_name" {
  default = "faa"
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

variable "enable_locks" {
  type = bool
  default = false
  description = "Apply RG locks if set to true"
}
