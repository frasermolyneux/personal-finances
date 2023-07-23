resource "azurerm_key_vault_secret" "appdata_connectionstring" {
  for_each = toset(var.locations)

  name         = format("%s-connectionstring", azurerm_storage_account.storage_account.name)
  value        = azurerm_storage_account.storage_account.primary_connection_string
  key_vault_id = azurerm_key_vault.kv[each.value].id
}
