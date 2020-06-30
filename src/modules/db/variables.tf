variable "NAME" {
  type        = string
  description = "The prefix which should be used for all resources in this example"
}

variable "COSMOS_RG_NAME" {
  type        = string
  description = "The Azure Resource Group the resource should be added to"
}

variable "LOCATION" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

variable "COSMOS_RU" {
  type    = number
  default = 400
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
variable "acr" {
  type        = string
  description = "The helium acr created by the ACR module and passed to the DB module"
  default     = "helium-csharp"
}
