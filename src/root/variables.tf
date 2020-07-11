variable "NAME" {
  type        = string
  description = "The prefix which should be used for all resources in this example. Used by all modules"
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

variable "ACTION_GROUP_NAME" {
  type        = string
  description = "The action group name to pass to the web insights alert creation command.  Used by the ALERTS Module"
}
variable "EMAIL_FOR_ALERTS" {
  type        = string
  description = "The name of the email or email group to receive alerts"
}
variable "RT_THRESHOLD" {
  type        = string
  description = "This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21"
}
variable "RT_FREQUENCY" {
  type        = string
  description = "The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be les than WindowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D"
}
variable "RT_OPERATOR" {
  type        = string
  description = "The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual"
}
variable "RT_WINDOW_SIZE" {
  type        = string
  description = "The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default if PT5M"
}
variable "RT_SEVERITY" {
  type        = string
  description = "The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3"
}
variable "MR_THRESHOLD" {
  type        = string
  description = "This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21"
}
variable "MR_FREQUENCY" {
  type        = string
  description = "The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be less than windowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D"
}
variable "MR_OPERATOR" {
  type        = string
  description = "The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual"
}
variable "MR_WINDOW_SIZE" {
  type        = string
  description = "The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default if PT5M"
}
variable "MR_SEVERITY" {
  type        = string
  description = "The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3"
}
variable "WT_THRESHOLD" {
  type        = string
  description = "This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21"
}
variable "WT_FREQUENCY" {
  type        = string
  description = "The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be less than windowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D"
}
variable "WT_OPERATOR" {
  type        = string
  description = "The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual"
}
variable "WT_WINDOW_SIZE" {
  type        = string
  description = "The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default if PT5M"
}
variable "WT_SEVERITY" {
  type        = string
  description = "The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3"
}

variable "WV_THRESHOLD" {
  type        = string
  description = "This is a number that is used with Operator to activate the alert, for example if threshold was set to 20 and Operator was GreaterThan, the alert would activate at 21"
}

variable "WV_FREQUENCY" {
  type        = string
  description = "The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be less than windowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D"
}

variable "WV_OPERATOR" {
  type        = string
  description = "The criteria operator - possible values are Equals NotEquals GreaterThan TreaterThanOrEqual LessThan and LessThanOrEqual"
}

variable "WV_WINDOW_SIZE" {
  type        = string
  description = "The period of time use to monitor alert activity represented in ISO 8601 duration format  This value must be greater than frequency and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D - the default is PT5M"
}

variable "WV_SEVERITY" {
  type        = string
  description = "The severity to assign to the alert with possible values of 0, 1, 2, 3, and 4 - the default is 3"
}

variable "WEBV_INSTANCES" {
  type        = map(number)
  description = "List of additional webv test locations"
}
