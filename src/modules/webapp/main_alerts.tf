resource "random_uuid" "appsguid" {}
resource "random_uuid" "webtestguid" {}

resource "azurerm_monitor_action_group" "helium-action-group" {
  name                = "${var.NAME}-action-group"
  resource_group_name = var.APP_RG_NAME
  short_name          = var.NAME
  email_receiver {
    name                    = "${var.NAME}-alert-receiver"
    email_address           = var.EMAIL_FOR_ALERTS
    use_common_alert_schema = false
  }
}

resource "azurerm_application_insights_web_test" "helium-web-test" {
  depends_on = [
    var.APP_SERVICE_DONE,
    azurerm_monitor_action_group.helium-action-group #TODO Modify depends on to remove hard dependency
  ]
  name                    = "${var.NAME}-web-test"
  location                = var.LOCATION
  resource_group_name     = var.APP_RG_NAME
  description             = "web test (/healthz)"
  enabled                 = "true"
  application_insights_id = azurerm_application_insights.helium.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 300
  geo_locations           = ["us-ca-sjc-azr", "us-tx-sn1-azr", "us-il-ch1-azr", "us-va-ash-azr", "us-fl-mia-edge"]
  configuration           = <<XML
<WebTest Name="WebTest1" Id="${random_uuid.appsguid.result}" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="${random_uuid.webtestguid.result}" Version="1.1" Url="https://${var.NAME}.azurewebsites.net/healthz" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML
}

resource "azurerm_monitor_metric_alert" "generic-alert" {
  for_each            = var.ALERT_RULES
  depends_on          = [azurerm_application_insights_web_test.helium-web-test]
  name                = "${var.NAME}-${each.value["name"]}"
  resource_group_name = var.APP_RG_NAME
  scopes              = [azurerm_application_insights.helium.id]
  frequency           = each.value["frequency"]
  window_size         = each.value["window_size"]
  description         = each.value["description"]
  severity            = each.value["severity"]
  auto_mitigate       = "false"
  enabled             = each.value["enabled"]
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = each.value["metric_name"]
    aggregation      = each.value["aggregation"]
    operator         = each.value["operator"]
    threshold        = each.value["threshold"]
  }
  action {
    action_group_id = azurerm_monitor_action_group.helium-action-group.id
  }
}


resource "azurerm_monitor_metric_alert" "web-test-alert" {
  for_each            = var.WEBTEST_ALERT_RULES
  depends_on          = [azurerm_application_insights_web_test.helium-web-test]
  name                = "${var.NAME}-${each.value["name"]}"
  resource_group_name = var.APP_RG_NAME
  scopes              = [azurerm_application_insights.helium.id]
  frequency           = each.value["frequency"]
  window_size         = each.value["window_size"]
  description         = each.value["description"]
  severity            = each.value["severity"]
  auto_mitigate       = "false"
  enabled             = each.value["enabled"]
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = each.value["metric_name"]
    aggregation      = each.value["aggregation"]
    operator         = each.value["operator"]
    threshold        = each.value["threshold"]
    dimension {
      name     = "availabilityResult/location"
      operator = "Include"
      values   = ["*"]
    }
  }
  action {
    action_group_id = azurerm_monitor_action_group.helium-action-group.id
  }
}

