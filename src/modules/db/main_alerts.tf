resource "azurerm_monitor_action_group" "cosmos-action-group" {
  name                      = "cosmos-action-group"
  resource_group_name       = var.COSMOS_RG_NAME
  short_name                = var.NAME
  email_receiver {
    name                    = "${var.NAME}-alert-receiver"
    email_address           = var.EMAIL_FOR_ALERTS
    use_common_alert_schema = false
  }
}

resource "azurerm_monitor_metric_alert" "cosmos-alert" {
  depends_on          = [ null_resource.imdb-import ]
  name                = "${var.NAME}-cosmos-throttle-alert"
  resource_group_name = var.COSMOS_RG_NAME
  scopes              = [azurerm_cosmosdb_account.cosmosdb.id]
  frequency           = "PT1M"
  window_size         = "PT5M"
  description         = "Cosmos DB Requests Throttling"
  severity            = 2
  auto_mitigate       = "false"
  enabled             = true
  criteria {
    metric_namespace = "Microsoft.DocumentDB/databaseAccounts"
    metric_name      = "TotalRequests"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = "0"
    dimension {
      name            = "StatusCode"
      operator        = "Include"
      values          = ["429"]
    }
  }
  action {
    action_group_id   = azurerm_monitor_action_group.cosmos-action-group.id
  }
}
