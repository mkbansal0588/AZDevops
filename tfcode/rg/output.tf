output "name" {
  value       = azurerm_resource_group.rg[*].name
  description = "Le nom du ressource groupe cree"
}

output "id" {
  value       = azurerm_resource_group.rg[*].id
  description = "L,id du ressource groupe cree"
}

output "location" {
  value       = azurerm_resource_group.rg[*].location
  description = "Location du resource group"
}

