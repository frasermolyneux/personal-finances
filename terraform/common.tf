resource "azurerm_resource_group" "rg" {
  for_each = toset(var.locations)

  name     = format("rg-personal-finances-%s-%s-%s", var.environment, each.value, var.instance)
  location = each.value

  tags = var.tags
}
