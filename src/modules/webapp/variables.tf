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

variable "TFSTATE_RG_NAME" {
  type        = string
  description = "The Azure Resource Group the tfstate files should be added to"
}

variable "REPO" {
  type        = string
  description = "The helium repo"
}
variable "acr" {
  type        = string
  description = "The helium acr created by the ACR module and passed to the this module"
  default     = "helium-csharp"
}

variable "LOGINSERVER" {
  type        = string
  description = "The acr login server created by the ACR module and passed to the this module"
}
variable "IMDB_IMPORT_DONE" {
  description = "ACI module dependency complete"
  type        = bool
}

variable "ACTION_GROUP_NAME" {
  description = "Name of action group or email group to receive alerts"
  type        = string

}
variable "EMAIL_FOR_ALERTS" {
  type        = string
  description = "The name of the email or email group to receive alerts"

}
variable "TF_SUB_ID" {
  type        = string
  description = "The subscription ID in which to create these appInsights alerts"
}
variable "RT_FREQUENCY" {
  type        = string
  description = "The frequency to test the metric during Window Size represented in ISO 8601 duration format  This value must be les than WindowSize and possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and PT1D"
}
variable "RT_WINDOW_SIZE" {
  type        = string
  description = "The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M. "
}
variable "RT_SEVERITY" {
  type        = number
  description = "The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4. Defaults to 3. "
}
variable "RT_THRESHOLD" {
  type        = string
  description = "(Required) The criteria threshold value that activates the alert. "
}
variable "RT_OPERATOR" {
  type        = string
  description = "(Required) The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual."
}
variable "MR_FREQUENCY" {
  type        = string
  description = "The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format. Possible values are PT1M, PT5M, PT15M, PT30M and PT1H. Defaults to PT1M"
}
variable "MR_WINDOW_SIZE" {
  type        = string
  description = "The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M. "
}
variable "MR_SEVERITY" {
  type        = number
  description = "The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4. Defaults to 3. "
}
variable "MR_THRESHOLD" {
  type        = string
  description = "(Required) The criteria threshold value that activates the alert. "
}
variable "MR_OPERATOR" {
  type        = string
  description = "(Required) The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual."
}
variable "WT_FREQUENCY" {
  type        = string
  description = "The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format. Possible values are PT1M, PT5M, PT15M, PT30M and PT1H. Defaults to PT1M"
}
variable "WT_WINDOW_SIZE" {
  type        = string
  description = "The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M. "
}
variable "WT_SEVERITY" {
  type        = number
  description = "The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4. Defaults to 3. "
}
variable "WT_THRESHOLD" {
  type        = string
  description = "(Required) The criteria threshold value that activates the alert. "
}
variable "WT_OPERATOR" {
  type        = string
  description = "(Required) The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual."
}
variable "WV_FREQUENCY" {
  type        = string
  description = "The evaluation frequency of this Metric Alert, represented in ISO 8601 duration format. Possible values are PT1M, PT5M, PT15M, PT30M and PT1H. Defaults to PT1M"
}
variable "WV_WINDOW_SIZE" {
  type        = string
  description = "The period of time that is used to monitor alert activity, represented in ISO 8601 duration format. This value must be greater than frequency. Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D. Defaults to PT5M. "
}
variable "WV_SEVERITY" {
  type        = number
  description = "The severity of this Metric Alert. Possible values are 0, 1, 2, 3 and 4. Defaults to 3. "
}
variable "WV_THRESHOLD" {
  type        = string
  description = "(Required) The criteria threshold value that activates the alert. "
}
variable "WV_OPERATOR" {
  type        = string
  description = "(Required) The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual."
}

