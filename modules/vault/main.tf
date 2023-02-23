data "azurerm_client_config" "current" {}

 resource "azurerm_key_vault" "kv" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  tags                        = var.common_tags
  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "kvPermissions" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "get"
  ]

  certificate_permissions = [
    "create",
    "delete",
    "get",
    "import",
    "list",
    "update"
  ]
}

resource "azurerm_key_vault_certificate" "kvCertificate" {
  name         = "apim-didago-nl-tls-certificate"
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64("certificates/${var.apimProxyHostConfig.certificateFilename}")
    password = var.apimProxyHostConfigCertificatePassword
  }

  certificate_policy {
    issuer_parameters {
      name = var.apimProxyHostConfig.certificateIssuer
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

# this is for later, to allow apim to get cert from kv managed identities on the APIM resource is enabled.
# resource "azurerm_key_vault_access_policy" "kvApimPolicy" {
#   key_vault_id = azurerm_key_vault.kv.id

#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = azurerm_api_management.apim.identity.0.principal_id

#   secret_permissions = [
#     "get"
#   ]

#   certificate_permissions = [
#     "get",
#     "list"
#   ]
# }