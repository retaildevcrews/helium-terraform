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
