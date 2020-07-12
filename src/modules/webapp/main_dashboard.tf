resource "azurerm_dashboard" "helium-dashboard" {
  depends_on          = [ var.APP_SERVICE_DONE ]
  name                = "Helium-Dashboard-${var.NAME}"
  resource_group_name = var.APP_RG_NAME
  location            = var.LOCATION
  tags = {
    source = "terraform"
  }

  dashboard_properties = templatefile("${path.module}/dash.tpl",
    {
      md_content = "Helium Dashboard",
      sub_id     = var.TF_SUB_ID
      name       = var.NAME
      rg         = var.APP_RG_NAME
      cosmos_rg  = var.COSMOS_RG_NAME
      db         = var.COSMOS_DB
  })
}
