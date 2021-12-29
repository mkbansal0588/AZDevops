output "rg" {
  value = azurerm_storage_account.adls[*].resource_group_name
}

output "name" {
  value = azurerm_storage_account.adls[*].resource_group_name
}

output "id" {
  value = azurerm_storage_account.adls[*].id
}
