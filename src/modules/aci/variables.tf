variable "NAME" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
}

variable "ACI_RG_NAME" {
  description = "The Azure Resource Group the resource should be added to"
  type        = string
}

variable "LOCATION" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
}

variable "CONTAINER_FILE_NAME" {
  description = "The file name to pass to the container command."
  type        = string
}

variable "APP_SERVICE_DONE" {
  description = "ACI module dependency complete"
  type        = bool
}

variable "REPO" {
  description = "helium repo to use"
  type        = string
}

variable "WEBV_INSTANCES" {
  type = map(string)
}
