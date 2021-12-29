output "data_factory_name" {
  value       = azurerm_data_factory.adf[*].name
  description = "Nom de la Data Factory créée"
}

output "data_factory_identity" {
  value       = azurerm_data_factory.adf[*].identity[0].principal_id
  description = "ID d'objet de l'identité gérée de la Data Factory créée"
}

output "data_factory_id" {
  value       = azurerm_data_factory.adf[*].id
  description = "ID de ressource de la fabrique de données"
}

output "auth_key_1" {
  value       = azurerm_data_factory_integration_runtime_self_hosted.shir[*].auth_key_1
  description  = "The primary integration runtime authentication key."
}


output "auth_key_2" {
  value       = azurerm_data_factory_integration_runtime_self_hosted.shir[*].auth_key_2
  description  = "The secondary integration runtime authentication key."
}


output "id" {
  value       = azurerm_data_factory_integration_runtime_self_hosted.shir[*].id
  description  = "The ID of the Data Factory."
}

output "adf_custom_dns_configs" {
  description = "DNS config for private endpoint for ACR"
  value       = module.pep[*].custom_dns_configs
}