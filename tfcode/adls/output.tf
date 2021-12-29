output "rg" {
  value = azurerm_storage_account.adls[*].resource_group_name
}

output "name" {
  value = azurerm_storage_account.adls[*].resource_group_name
}

output "id" {
  value = azurerm_storage_account.adls[*].id
}

output "url" {
  value = azurerm_storage_account.adls[*].primary_dfs_endpoint
}

output "adls_custom_dns_configs" {
  value = module.pep[*].custom_dns_configs
}