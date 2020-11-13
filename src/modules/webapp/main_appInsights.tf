resource azurerm_application_insights helium {
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.APP_RG_NAME
  application_type    = "web"
}
