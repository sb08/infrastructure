variable "apim_name" {
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

variable "virtual_network_type" {
    description = "The vNet networking model."
    type        = string
    default     = "External"
}

variable "apis" {
  type        = list(string)
  description = "api management apis"
  default     = ["registration", "message"]
}

variable "vnet" {
    description = "name of the virtual network"
}

variable "public_ip_address_id" {
    description = "The Virtual Network public ip identifier."
    type        = string
}

variable "subnet" {
    description = "The vnet subnet configuted for api management."
    type        = string
    default     = "apim"
}
