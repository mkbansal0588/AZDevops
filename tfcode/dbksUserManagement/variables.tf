variable "haveSpToAddToDBGroups" {
  type        = bool
  description = "Specify if you have any service principal to add databricks local group"
  default = true
}

variable "haveSpToSyncWithWorkspace" {
  type        = bool
  description = "Specify if you want service principal to sync with databricks workspace."
  default = true
}

variable "group_display_name" {
  type        = string
  description = "(Required) Display name of the group. The group must exist before this resource can be planned."
  default = ""
}

variable "sp_display_name" {
  type        = string
  description = "(Required) This is an alias for the service principal and can be the full name of the service principal."
  default = ""
}

variable "sp_application_id" {
  type        = string
  description = "This is the application id of the given service principal and will be their form of access and identity. On other clouds than Azure this value is auto-generated."
  default = ""
}