variable "sb_name" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources"
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group service is assigned to."
}

variable "apim_name" {
  description = "Name of the resource group service is assigned to."
}

variable "apis" {
  type        = list(string)
  description = "api management apis"
  default     = ["registration", "message"]
}

variable "open_api_spec_content_value" {
    description = "swagger json url"
}

variable "open_api_spec_content_format" {
    description = "open api doc comes from url"
}