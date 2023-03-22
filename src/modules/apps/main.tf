resource "azurerm_service_plan" "app_sp" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "identity" {
  name                = var.auth_name
  resource_group_name = var.resource_group_name
  location            = azurerm_service_plan.app_sp.location
  service_plan_id     = azurerm_service_plan.app_sp.id
  depends_on = [
    azurerm_service_plan.app_sp,
  ]
  site_config {
        app_command_line = "dotnet identity.dll"
  }
  app_settings = {
    BffRedirectUri = "https://${var.js_name}.azurewebsites.net/signin-oidc"
    BffPostLogoutRedirectUri =  "https://${var.js_name}.azurewebsites.net/signout-callback-oidc"
    BffBackChannelLogoutUri = "https://${var.js_name}.azurewebsites.net/bff/backchannel"
    JsRedirectUri = "http://localhost:4200"
    JsPostLogoutRedirectUris = "http://localhost:4200"
    JsAllowedCorsOrigin = "http://localhost:4200"
  }
}

# data "azurerm_servicebus_namespace_authorization_rule" "authRule" {
#   name                = "messagebus-policy"
#   namespace_name      = var.sb_name
#   resource_group_name = var.resource_group_name
# }
#
# resource "azurerm_linux_web_app" "api" {
#   name                = var.api_name
#   resource_group_name = var.resource_group_name
#   location            = azurerm_service_plan.app_sp.location
#   service_plan_id     = azurerm_service_plan.app_sp.id
#   depends_on = [
#     azurerm_service_plan.app_sp,
#   ]
#   site_config {
#         app_command_line = "dotnet api.dll"
#   }
#   app_settings = {
#     "Authority" = "https://ltf-id-dev.azurewebsites.net"
#     "SbConnectionString" = data.azurerm_servicebus_namespace_authorization_rule.authRule.primary_connection_string
#     "AllowedCorsOrigins" = "https://ltf-apim-dev.azure-api.net http://localhost:4200"
#   }
# }
#
# resource "azurerm_linux_web_app" "bff" {
#   name                = var.js_name
#   resource_group_name = var.resource_group_name
#   location            = azurerm_service_plan.app_sp.location
#   service_plan_id     = azurerm_service_plan.app_sp.id
#   depends_on = [
#     azurerm_service_plan.app_sp,
#   ]
#   site_config {
#     app_command_line = "dotnet bff.dll"
#   }
#   app_settings = {
#     "Authority" = "https://ltf-id-dev.azurewebsites.net"
#     "RemoteUri" = "https://ltf-api-dev.azurewebsites.net"
#     "ApimUri" = "https://ltf-apim-dev.azure-api.net"
#   }
# }
#
# resource "azurerm_static_site" "ng" {
#   name                = "ng"
#   resource_group_name = var.resource_group_name
#   location            = "eastus2"
# }
