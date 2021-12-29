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

variable "extra_tags" {
  type = map
  default = null
  description = "Les TAGS que doit faire partie des tags du resource."
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
