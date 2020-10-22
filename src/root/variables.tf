variable "NAME" {
  type        = string
  description = "The prefix which should be used for all resources in this example. Used by all modules"

  validation {
    condition     = length(var.NAME) < 2
    error_message = "Testing validations, this should definitely fail."
  }
}

variable "TF_CLIENT_ID" {
  type        = string
  description = "The Client ID(AppID) of the Service Principal that TF will use to Authenticate and build resources as. This account should have at least Contributor Role on the subscription. This is only used by the parent main.tf"

}
variable "TF_CLIENT_SECRET" {
  type        = string
  description = "The Client Secret of the Service Principal that TF will use to Authenticate and build resources as. This account should have at least Contributor Role on the subscription. This is only used by the parent main.tf"
}

variable "ACR_SP_ID" {
  type        = string
  description = "The ACR Service Principal ID"
}

variable "ACR_SP_SECRET" {
  type        = string
  description = "The ACR Service Principal secret"
}

variable "TF_TENANT_ID" {
  type        = string
  description = "This is the tenant ID of the Azure subscription. This is only used by the parent main.tf"
}

variable "TF_SUB_ID" {
  type        = string
  description = "The Subscription ID for the Terrafrom Service Principal to build resources in.This is only used by the parent main.tf"
}

variable "LOCATION" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created. Used by all modules"
}

variable "CONTAINER_FILE_NAME" {
  type        = string
  description = "The file name to pass to the container command. Used by the ACI Module"
}

variable "COSMOS_RU" {
  type        = number
  description = "The Number of Resource Units allocated to the CosmosDB. This is used by the DB module"
}

variable "COSMOS_DB" {
  type        = string
  description = "The Cosmos DB database name"
  default     = "imdb"
}

variable "COSMOS_COL" {
  type        = string
  description = "The Cosmos DB collection name"
  default     = "movies"
}

variable "REPO" {
  type        = string
  description = "The helium repo"
  default     = "helium-csharp"
}

variable "EMAIL_FOR_ALERTS" {
  type        = string
  description = "The name of the email or email group to receive alerts"
}

variable "WEBV_INSTANCES" {
  type        = map(number)
  description = "List of additional webv test locations"
}
variable "ALERT_RULES" {
  type = map(object({
    name        = string #i.e. "response-time-alert"
    frequency   = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H
    window_size = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H,PT6H,PT12H,PT24H
    description = string
    severity    = number # Allowed Values: 0,1,2,3,4
    enabled     = bool   # Specifies is Alert is enabled
    operator    = string # Allowed Values: Equals,NotEquals,GreaterThan,GeaterThanOrEqual,LessThan,LessThanOrEqual
    threshold   = string # The threshold value at which the alert is activated.
    aggregation = string #Allowed Values: Average,Minimum,Maximum,Total,Count
    metric_name = string
  }))
  description = "These are customizable values required to set standard metric alerts. See https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-overview for details"
}
variable "WEBTEST_ALERT_RULES" {
  type = map(object({
    name        = string #i.e. "response-time-alert"
    frequency   = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H
    window_size = string # Allowed Values: PT1M,PT5M,PT15M,PT30M,PT1H,PT6H,PT12H,PT24H
    description = string
    severity    = number # Allowed Values: 0,1,2,3,4
    enabled     = bool   # Specifies is Alert is enabled
    operator    = string # Allowed Values: Equals,NotEquals,GreaterThan,GeaterThanOrEqual,LessThan,LessThanOrEqual
    threshold   = string # The threshold value at which the alert is activated.
    aggregation = string #Allowed Values: Average,Minimum,Maximum,Total,Count
    metric_name = string
  }))
  description = "These are customizable values required to set webtest alerts which require a dimension criteria. See https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-overview for details"
}
