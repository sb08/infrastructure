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
  default      = "B2"
}

variable "subnet_names" {
  type = list(string)
  default = ["apim", "apps", "privatelink", "sbus"]
}

variable "subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/28", "10.0.3.0/28", "10.0.4.0/24"]
}

variable "vnet_cidr_range" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_count" {
  type = number
  default = 3
}

variable "nsg_ids" {
  type = map(string)
  default = { "apim" = "apim_sg" }
}

# todo: put this in kv
# variable "sbConnectionString" {
#   description = "Service bus connection string."
#   type        = string
# }

variable "apim_pip_name" {
  description = "public ip for ami management."
  type        = string
  default     = "ltf-apimpip"
}

variable "app_service_plan_name" {
    description = "Common service plan for app services."
}
