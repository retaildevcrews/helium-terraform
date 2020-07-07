resource "random_uuid" "appsguid" {}
resource "random_uuid" "webtestguid" {}


resource "azurerm_monitor_action_group" "helium-action-group" {
  name                = var.ACTION_GROUP_NAME
  resource_group_name = var.APP_RG_NAME
  short_name          = substr("${var.ACTION_GROUP_NAME}", 0, 12)
  email_receiver {
    name                    = "${var.NAME}-alert-receiver"
    email_address           = var.EMAIL_FOR_ALERTS
    use_common_alert_schema = false
  }
}

resource "azurerm_monitor_metric_alert" "response-time-alert" {
  name                = "${var.NAME}-response-time-alert"
  resource_group_name = var.APP_RG_NAME
  scopes              = [azurerm_application_insights.helium.id]
  frequency           = var.RT_FREQUENCY
  window_size         = var.RT_WINDOW_SIZE
  description         = "Server Response Time Too High"
  severity            = var.RT_SEVERITY
  auto_mitigate       = "false"
  enabled             = "false"
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = var.RT_OPERATOR
    threshold        = var.RT_THRESHOLD
  }
  action {
    action_group_id = azurerm_monitor_action_group.helium-action-group.id
  }
}
resource "azurerm_monitor_metric_alert" "requests-too-high-alert" {
  name                = "${var.NAME}-requests-too-high-alert"
  resource_group_name = var.APP_RG_NAME
  scopes              = [azurerm_application_insights.helium.id]
  frequency           = var.MR_FREQUENCY
  window_size         = var.MR_WINDOW_SIZE
  description         = "Requests Too High"
  severity            = var.MR_SEVERITY
  auto_mitigate       = "false"
  enabled             = "false"
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/count"
    aggregation      = "Count"
    operator         = var.MR_OPERATOR
    threshold        = var.MR_THRESHOLD
  }
  action {
    action_group_id = azurerm_monitor_action_group.helium-action-group.id
  }
}
resource "azurerm_application_insights_web_test" "helium-web-test" {
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

resource "azurerm_monitor_metric_alert" "helium-web-test-alert" {
  name                = "${var.NAME}-web-test-alert"
  resource_group_name = var.APP_RG_NAME
  scopes              = [azurerm_application_insights.helium.id]
  frequency           = var.WT_FREQUENCY
  window_size         = var.WT_WINDOW_SIZE
  description         = "Web Test Alert"
  severity            = var.WT_SEVERITY
  auto_mitigate       = "false"
  enabled             = "false"
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = var.WT_OPERATOR
    threshold        = var.WT_THRESHOLD
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
resource "azurerm_monitor_metric_alert" "requests-too-low-alert" {
  name                = "${var.NAME}-requests-too-low-alert"
  resource_group_name = var.APP_RG_NAME
  scopes              = [azurerm_application_insights.helium.id]
  frequency           = var.WV_FREQUENCY
  window_size         = var.WV_WINDOW_SIZE
  description         = "Requests Too Low"
  severity            = var.WV_SEVERITY
  auto_mitigate       = "false"
  enabled             = "true"
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/count"
    aggregation      = "Count"
    operator         = var.WV_OPERATOR
    threshold        = var.WV_THRESHOLD
  }
  action {
    action_group_id = azurerm_monitor_action_group.helium-action-group.id
  }
}