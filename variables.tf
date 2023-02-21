variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "ltf"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "destin"
}

variable "resource_group_name" {
  type    = string
  default = "infra"
}

variable "sp_name" {
  type    = string
  default = "ltf-sp"
}

variable "storageAccountSku" {
  default = {
    tier = "Standard"
    type = "GRS"
  }
}

variable "swagger-json" {
  type    = string
  default = "openapi+json"
  # other values: "swagger-link-json"
  # turn this into a map(string)
}

variable "swagger-json-url" {
  type    = string
  default = "https://ltf-api-42091-dev.azurewebsites.net/swagger/v1/swagger.json\n\n"
}

variable "location" {
  type    = string
  default = "australiaeast"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "infra"
}

resource "random_id" "id" {
  byte_length = 4
}

variable "vnet_cidr_range" {
  type = list(any)
}

variable "sku_name" {
  description = "Service plan and hardware selection definition. Defaults to basic."
  default     = "B1"
}

variable "subnet_names" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "subnet_count" {
  type = number
}

variable "nsg_ids" {
  type = map(string)
}

variable "sbConnectionString" {
  description = "Service bus connection string."
  type        = string
}
