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

variable "rg" {
  type    = string
  default = "rg"
}

variable "storageAccountSku" {
  default = {
    tier = "Standard"
    type = "GRS"
  }
}

variable "location" {
  type = string
  default = "australiaeast"
  # default = "centralus"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "az-infrastructure"
}

# resource "random_id" "id" {
#   byte_length = 4
# }

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

variable "vnet_cidr_range" {
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

variable "apim_pip_name" {
  description = "public ip for ami management."
  type        = string
  default     = "ltf-apimpip"
}
