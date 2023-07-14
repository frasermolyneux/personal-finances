

resource "azurerm_service_plan" "app" {
  for_each = toset(var.locations)

  name = format("plan-personal-finances-%s-%s-%s", var.environment, each.value, var.instance)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  os_type  = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "app" {
  for_each = toset(var.locations)

  name = format("app-personal-finances-%s-%s-%s-%s", var.environment, each.value, var.instance, random_id.environment_id.hex)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  service_plan_id = azurerm_service_plan.app[each.value].id

  https_only = true

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.ai[each.value].instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.ai[each.value].connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }

  site_config {
    always_on = false // This is required as the app service plan is set to 'F1' which is not always on.

    ftps_state = "Disabled"

    application_stack {
      dotnet_version = "7.0"
    }
  }
}

// This is required as when the app service is created 'basic auth' is set as disabled which is required for the SCM deploy.
resource "azapi_update_resource" "app" {
  for_each = toset(var.locations)

  type        = "Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01"
  resource_id = format("%s/basicPublishingCredentialsPolicies/scm", azurerm_linux_web_app.app[each.value].id)

  body = jsonencode({
    properties = {
      allow = true
    }
  })

  depends_on = [
    azurerm_linux_web_app.app,
  ]
}
