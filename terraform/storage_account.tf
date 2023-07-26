resource "azurerm_storage_account" "storage_account" {
  name = format("saad%s", random_id.environment_id.hex)

  resource_group_name = azurerm_resource_group.rg[var.primary_location].name
  location            = azurerm_resource_group.rg[var.primary_location].location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "monzo_in" {
  name                  = "monzo-in"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "monzo_processed" {
  name                  = "monzo-processed"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "barclays_in" {
  name                  = "barclays-in"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "barclays_processed" {
  name                  = "barclays-processed"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_table" "transactions" {
  name                 = "transactions"
  storage_account_name = azurerm_storage_account.storage_account.name
}
