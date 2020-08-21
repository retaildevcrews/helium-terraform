LOCATION            = "<<He_Location>>"
REPO                = "<<He_Repo>>"
NAME                = "<<He_Name>>"
TF_CLIENT_ID        = "<<HE_CLIENT_ID>>"
TF_CLIENT_SECRET    = "<<HE_CLIENT_SECRET>>"
TF_SUB_ID           = "<<HE_SUB_ID>>"
TF_TENANT_ID        = "<<HE_TENANT_ID>>"
ACR_SP_ID           = "<<HE_ACR_SP_ID>>"
ACR_SP_SECRET       = "<<HE_ACR_SP_SECRET>>"
WEBV_INSTANCES = {
  "<<He_Location>>" = 1000
  "eastus2" = 5000
  "westeurope" = 15000
  "southeastasia" = 30000
}
CONTAINER_FILE_NAME = "benchmark.json"
COSMOS_RU           = "1000"
EMAIL_FOR_ALERTS    = "<<He_Email>>"
ALERT_RULES         = {
  rt_alerts = {
    name = "response-time-alert"
    frequency = "PT15M"
    window_size = "PT30M"
    description = "Server Response Time Too High"
    severity = 2
    enabled = false
    operator = "GreaterThan"
    threshold = "900"
    aggregation = "Average"
    metric_name = "requests/duration"
    },
  mr_alerts = {
    name = "requests-too-high-alert"
    frequency = "PT1M"
    window_size = "PT15M"
    description = "Requests Too High"
    severity = 2
    enabled = false
    operator = "GreaterThan"
    threshold = "900"
    aggregation = "Count"
    metric_name = "requests/count"
  },
  wv_alerts = {
    name = "requests-too-low-alert"
    frequency = "PT1M"
    window_size = "PT5M"
    description = "Requests Too Low"
    severity = 2
    enabled = true
    operator = "LessThan"
    threshold = "1"
    aggregation = "Count"
    metric_name = "requests/count"
  }
}
WEBTEST_ALERT_RULES     = {
  wt_rules = {
    name = "web-test-alert"
    frequency = "PT5M"
    window_size = "PT15M"
    description = "Web Test Alert"
    severity = 2
    enabled = false
    operator = "LessThan"
    threshold = "1"
    aggregation = "Average"
    metric_name = "availabilityResults/availabilityPercentage"
  }
}

