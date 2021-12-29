output "name" {
  value       = azurerm_resource_group.rg[*].name
  description = "Resource group names"
}

output "id" {
  value       = azurerm_resource_group.rg[*].id
  description = "Resource group ids"
}

output "location" {
  value       = azurerm_resource_group.rg[*].location
  description = "Resource group location"
}
