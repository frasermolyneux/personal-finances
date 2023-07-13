resource "azurerm_application_insights" "ai" {
  for_each = toset(var.locations)

  name = format("ai-personal-finances-%s-%s-%s", var.environment, each.value, var.instance)

  resource_group_name = azurerm_resource_group.rg[each.value].name
  location            = azurerm_resource_group.rg[each.value].location

  workspace_id = "/subscriptions/${var.log_analytics_subscription_id}/resourceGroups/${var.log_analytics_resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspace_name}"

  application_type = "web"
}
