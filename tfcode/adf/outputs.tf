output "data_factory_name" {
  value       = azurerm_data_factory.adf[*].name
  description = "Name of Azure data factory."
}

output "data_factory_id" {
  value       = azurerm_data_factory.adf[*].id
  description = "Resource ID for data factory"
}
