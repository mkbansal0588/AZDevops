output "spId" {
  description = "Canonical unique identifier for the service principal."
  value = databricks_service_principal.sp[*].id
}

output "groupId" {
  description = "The id for the group object."
  value = data.databricks_group.group_name[*].id
}

output "groupMembers" {
  description = "Set of user identifiers, that can be modified with databricks_group_member resource."
  value = data.databricks_group.group_name[*].members
}