variable "NAME" {
  type        = string
  description = "The prefix which should be used for all resources in this example"
}

variable "ACR_RG_NAME" {
  type        = string
  description = "The Azure Resource Group the resource should be added to"
}

variable "ACR_SP_ID" {
  type        = string
  description = "The ACR Service Principal"
}

variable "ACR_SP_SECRET" {
  type        = string
  description = "The ACR Service Principal Secret"
}

variable "LOCATION" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

variable "REPO" {
  type        = string
  description = "The helium repo"
}
