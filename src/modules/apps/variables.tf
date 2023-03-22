variable "auth_name" {
  description = "The prefix which should be used for all resources in this example"
}

variable "api_name" {
  description = "The prefix which should be used for all resources in this example"
}

variable "js_name" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "sku_name" {
  description = "Service plan and hardware selection definition. Defaults to basic."
  default     = "B1v2"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group service is assigned to."
}

variable "app_service_plan_name" {
    description = "Service plan for app services."
}

variable "sb_name" {
  description = "The prefix which should be used for all resources in this example"
}
