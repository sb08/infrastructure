resource "azurerm_service_plan" "app_sp" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "auth" {
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
    RedirectUri = "https://ltf-js-42901-dev.azurewebsites.net/signin-oidc"
    PostLogoutRedirectUri =  "https://ltf-js-42901-dev.azurewebsites.net/signout-callback-oidc"
    BackChannelLogoutUri = "https://ltf-js-42901-dev.azurewebsites.net/bff/backchannel"
  }
}

resource "azurerm_linux_web_app" "api" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  location            = azurerm_service_plan.app_sp.location
  service_plan_id     = azurerm_service_plan.app_sp.id
  depends_on = [
    azurerm_service_plan.app_sp,
  ]
  site_config {
        app_command_line = "dotnet api.dll"
  }
  app_settings = {
    "Authority" = "https://ltf-id-42901-dev.azurewebsites.net"
    "SbConnectionString" = var.sbConnectionString
  }
}

resource "azurerm_linux_web_app" "js" {
  name                = var.js_name
  resource_group_name = var.resource_group_name
  location            = azurerm_service_plan.app_sp.location
  service_plan_id     = azurerm_service_plan.app_sp.id
  depends_on = [
    azurerm_service_plan.app_sp,
  ]
  site_config {
    app_command_line = "dotnet JavaScriptClient.dll"
  }
  app_settings = {
    "Authority" = "https://ltf-id-42901-dev.azurewebsites.net"
    "RemoteUri" = "https://ltf-api-42901-dev.azurewebsites.net"
    "ApimUri" = "https://ltf-api-management-42901-dev.azure.api.net"
  }
}
