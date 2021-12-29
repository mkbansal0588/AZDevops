output "spId" {
  description = "Service Principal ID in workspace."
  value = module.user_management[*].spId
}
output "groupId" {
  description = "The id for the group object"
  value = databricks_group.group[*].id
}
output "databricks_ip_access_list_id" {
  description = "Canonical unique identifier for the IP Access List."
  value = databricks_ip_access_list.allowed-list[*].id
}
output "databricks_cluster_policy_id" {
  description = "Canonical unique identifier for the cluster policy. This is equal to policy_id."
  value = databricks_cluster_policy.clusterPolicy[*].id
}
output "databricks_cluster_policy_policyid" {
  description = "Canonical unique identifier for the cluster policy."
  value = databricks_cluster_policy.clusterPolicy[*].policy_id
}
output "databricks_cluster_policy_permissions_id" {
  description = "Canonical unique identifier for the permissions."
  value = databricks_permissions.clusterPolicyPermissions[*].id
}
output "databricks_cluster_policy_permissions_object_type" {
  description = "type of permissions."
  value = databricks_permissions.clusterPolicyPermissions[*].object_type
}
output "databricks_instance_pool_id" {
  description = "Canonical unique identifier for the instance pool."
  value = databricks_instance_pool.instance_pools[*].id
}
output "databricks_instance_pool_permission_id" {
  description = "Canonical unique identifier for the permissions."
  value = databricks_permissions.instance_pools_permissions[*].id
}
output "databricks_instance_pool_permission_object_type" {
  description = "type of permissions."
  value = databricks_permissions.instance_pools_permissions[*].object_type
}
