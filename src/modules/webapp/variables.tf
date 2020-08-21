variable "NAME" {
  type        = string
  description = "The prefix which should be used for all resources in this example"

}

variable "APP_RG_NAME" {
  type        = string
  description = "The Azure Resource Group the resource should be added to"

}

variable "COSMOS_RG_NAME" {
  type        = string
  description = "The Azure Resource Group the Cosmos DB is in"
}

variable "LOCATION" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."

}

variable "TENANT_ID" {
  type        = string
  description = "This is the tenant ID of the Azure subscription."
}

variable "COSMOS_URL" {
  type        = string
  description = "This is the primary connection string of the Cosmos DB and will be an output from the resource command."

}
variable "COSMOS_KEY" {
  description = "This is the managed identify key from the Cosmos DB and will be an output from the resource command."

}
variable "COSMOS_DB" {
  type        = string
  description = "This is the database name of the Cosmos DB and will be an output from the resource command."

}
variable "COSMOS_COL" {
  type        = string
  description = "This is the collection name of the Cosmos DB and will be an output from the resource command."

}

variable "ACR_SP_ID" {
  type        = string
  description = "The ACR Service Principal ID"
}

variable "ACR_SP_SECRET" {
  type        = string
  description = "The ACR Service Principal secret"
}

variable "APP_SERVICE_DONE" {
  description = "App Service dependency complete"
  type        = bool
}

variable "ACI_DONE" {
  description = "ACI dependency complete"
  type        = bool
}

variable "TFSTATE_RG_NAME" {
  type        = string
  description = "The Azure Resource Group the tfstate files should be added to"
}

variable "REPO" {
  type        = string
  description = "The helium repo"
}

variable "IMDB_IMPORT_DONE" {
  description = "ACI module dependency complete"
  type        = bool
}

variable "EMAIL_FOR_ALERTS" {
  type        = string
  description = "The name of the email or email group to receive alerts"

}

variable "TF_SUB_ID" {
  type        = string
  description = "The subscription ID in which to create these appInsights alerts"
}

variable "ALERT_RULES" {
  type = map(object({
    name = string #i.e. "response-time-alert"
    frequency = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H
    window_size = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H,PT6H,PT12H,PT24H
    description = string
    severity = number # Allowed Values: 0,1,2,3,4
    enabled = bool # Specifies is Alert is enabled
    operator = string # Allowed Values: Equals,NotEquals,GreaterThan,GeaterThanOrEqual,LessThan,LessThanOrEqual
    threshold = string # The threshold value at which the alert is activated.
    aggregation = string #Allowed Values: Average,Minimum,Maximum,Total,Count
    metric_name = string
  }))
  description = "These are customizable values required to set standard metric alerts. See https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-overview for details"
}
variable "WEBTEST_ALERT_RULES" {
  type = map(object({
    name = string #i.e. "response-time-alert"
    frequency = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H
    window_size = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H,PT6H,PT12H,PT24H
    description = string
    severity = number # Allowed Values: 0,1,2,3,4
    enabled = bool # Specifies is Alert is enabled
    operator = string # Allowed Values: Equals,NotEquals,GreaterThan,GeaterThanOrEqual,LessThan,LessThanOrEqual
    threshold = string # The threshold value at which the alert is activated.
    aggregation = string #Allowed Values: Average,Minimum,Maximum,Total,Count
    metric_name = string
  }))
  description = "These are customizable values required to set webtest alerts which require a dimension criteria. See https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-overview for details"
}