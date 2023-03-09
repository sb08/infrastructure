output "sb_name" {
  value = azurerm_servicebus_namespace.sb.name
  description = "The service bus resource name"
  sensitive = false
}

output "registration_topic_name" {
  value = azurerm_servicebus_namespace.sb.name
  description = "The service bus resource name"
  sensitive = false
}

output "sb_authRule_pk" {
  value = azurerm_servicebus_namespace_authorization_rule.authRule.primary_key
  description = "The service bus auth rule primary key"
  sensitive = true
}
