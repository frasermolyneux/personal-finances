resource "azurerm_resource_group" "func" {
  for_each = toset(var.locations)

  name     = format("rg-personal-finances-%s-func-%s-%s", var.environment, each.value, var.instance)
  location = each.value

  tags = var.tags
}

resource "azurerm_service_plan" "func" {
  for_each = toset(var.locations)

  name = format("plan-personal-finances-%s-func-%s-%s", var.environment, each.value, var.instance)

  resource_group_name = azurerm_resource_group.func[each.value].name
  location            = azurerm_resource_group.func[each.value].location

  os_type  = "Linux"
  sku_name = "Y1"

  tags = var.tags
}

resource "azurerm_storage_account" "func" {
  for_each = toset(var.locations)

  name = format("safn%s", random_id.environment_id.hex)

  resource_group_name = azurerm_resource_group.func[each.value].name
  location            = azurerm_resource_group.func[each.value].location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  tags = var.tags
}

resource "azurerm_linux_function_app" "func" {
  for_each = toset(var.locations)

  name = format("func-personal-finances-%s-%s-%s-%s", var.environment, each.value, var.instance, random_id.environment_id.hex)

  resource_group_name = azurerm_resource_group.func[each.value].name
  location            = azurerm_resource_group.func[each.value].location

  service_plan_id = azurerm_service_plan.func[each.value].id

  storage_account_name       = azurerm_storage_account.func[each.value].name
  storage_account_access_key = azurerm_storage_account.func[each.value].primary_access_key

  https_only = true

  functions_extension_version = "~4"

  site_config {
    application_stack {
      use_dotnet_isolated_runtime = true
      dotnet_version              = "7.0"
    }

    ftps_state          = "Disabled"
    always_on           = false
    minimum_tls_version = "1.2"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.ai[each.value].instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.ai[each.value].connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"

    "READ_ONLY_MODE"           = var.environment == "prd" ? "true" : "false"
    "WEBSITE_RUN_FROM_PACKAGE" = "1"

    // App Data Storage Account
    "appdata_connectionstring" = format("@Microsoft.KeyVault(VaultName=%s;SecretName=%s)", azurerm_key_vault.kv[each.value].name, azurerm_key_vault_secret.appdata_connectionstring[each.value].name)
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
