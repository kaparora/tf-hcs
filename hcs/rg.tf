data "azurerm_resource_group" "hcs" {
  name     = "${var.prefix}-hcs"
}