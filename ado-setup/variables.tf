variable "ado_org_service_url" {
  type        = string
  description = "Org service url for Azure DevOps"
}

variable "ado_github_repo" {
  type        = string
  description = "Name of the repository in the format <GitHub Org>/<RepoName>"
}

variable "ado_pipeline_yaml_path" {
  type        = string
  description = "Path to the yaml for the first pipeline"
}

variable "ado_github_pat" {
  type        = string
  description = "Personal authentication token for GitHub repo"
  sensitive   = true
}

variable "ado_terraform_version" {
  type        = string
  description = "Version of Terraform to use in the pipeline"
  default     = "1.0.3"
}

variable "prefix" {
  type        = string
  description = "Naming prefix for resources"
}

variable "az_location" {
  type    = string
  default = ""
}

variable "az_container_name" {
  type        = string
  description = "Name of container on storage account for Terraform state"
  default     = "terraform-state"
}

variable "az_state_key" {
  type        = string
  description = "Name of key in storage account for Terraform state"
  default     = "terraform.tfstate"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

locals {
  ado_project_name        = "${var.prefix}"
  ado_project_description = "Project for ${var.prefix}"
  ado_project_visibility  = "private"
  ado_pipeline_name_1     = "${var.prefix}-pipeline-1"
  ado_identity_pipeline     = "${var.prefix}-identity"

  az_resource_group_name  = "rg-${var.prefix}-${terraform.workspace}"
  az_storage_account_name = "sa${lower(var.prefix)}"
  az_key_vault_name       = "kv-destin-dev"

  pipeline_variables = {
    storageaccount   = azurerm_storage_account.sa.name
    container-name   = var.az_container_name
    key              = var.az_state_key
    sas-token        = data.azurerm_storage_account_sas.state.sas
    az-client-id     = azuread_application.resource_creation.application_id
    az-client-secret = random_password.resource_creation.result
    az-subscription  = data.azurerm_client_config.current.subscription_id
    az-tenant        = data.azurerm_client_config.current.tenant_id
  }

  azad_service_connection_sp_name = "ad-${var.prefix}-service-connection"
  azad_resource_creation_sp_name  = "ad-${var.prefix}-resource-creation"
}
