provider "azuredevops" {
}

resource "azuredevops_project" "project" {
  name               = local.ado_project_name
  description        = local.ado_project_description
  visibility         = local.ado_project_visibility
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
  }
}

resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "infrastructure"

  auth_personal {
    personal_access_token = var.ado_github_pat
  }
}

resource "azuredevops_resource_authorization" "auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  authorized  = true
}

resource "azuredevops_variable_group" "variablegroup" {
  project_id   = azuredevops_project.project.id
  name         = "infrastructure"
  description  = "Variable group for pipelines"
  allow_access = true

  variable {
    name  = "service_name"
    value = "key_vault"
  }

  variable {
    name  = "key_vault_name"
    value = local.az_key_vault_name
  }

  variable {
    name  = "project_id"
    value = azuredevops_project.project.id
  }

  variable {
    name  = "terraform_version"
    value = var.ado_terraform_version
  }
}

resource "azuredevops_build_definition" "infra" {

  depends_on = [azuredevops_resource_authorization.auth]
  project_id = azuredevops_project.project.id
  name       = local.ado_pipeline_name_1

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.ado_github_repo
    branch_name           = "azure-yaml-pipeline"
    yml_path              = "src/azure-pipelines.yml" # var.ado_pipeline_yaml_path_1
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  }
}

resource "azuredevops_serviceendpoint_azurerm" "key_vault" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "key_vault"
  description           = "Azure Service Endpoint for Key Vault Access"

  credentials {
    serviceprincipalid  = azuread_application.service_connection.application_id
    serviceprincipalkey = random_password.service_connection.result
  }

  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name

depends_on = [
    azuredevops_project.project
  ]
}

resource "azuredevops_resource_authorization" "kv_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.key_vault.id
  authorized  = true

  depends_on = [
    azuredevops_project.project, azuredevops_serviceendpoint_azurerm.key_vault
  ]
}
# # Key Vault task is here: https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-key-vault?view=azure-devops

resource "azuredevops_build_definition" "identity" {

  depends_on = [azuredevops_resource_authorization.auth]
  project_id = azuredevops_project.project.id
  name       = local.ado_identity_pipeline

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.ado_github_repo
    branch_name           = "azure-yaml-pipeline"
    yml_path              = "ltf-poc/src/identity/azure-pipelines.yml"
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  }
}
