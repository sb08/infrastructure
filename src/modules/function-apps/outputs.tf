output "broker-registration-function-app" {
  value = azurerm_linux_function_app.broker_registration.name
  description = "The broker registration function app resource name"
  sensitive = false
}
