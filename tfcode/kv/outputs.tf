output "rg" {
  description = "The ID of the Resource Group."
  value = data.azurerm_resource_group.rg.id
}

output "id" {
  description = "Resource ID of the keyVault resource"
  value = azurerm_key_vault.keyVault[*].id
}

output "vault_uri" {
  description = "The URI of the Key Vault, used for performing operations on keys and secrets"
  value = azurerm_key_vault.keyVault[*].vault_uri
}

output "kv_custom_dns_configs" {
  value = module.pep[*].custom_dns_configs
}