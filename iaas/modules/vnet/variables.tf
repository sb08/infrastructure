variable "vnet_name" {
  description = "The virtual network name"
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
