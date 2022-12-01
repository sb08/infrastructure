output "public_ip_addresses" {
  description = "The public ip addresses"
  value       = azurerm_api_management.apim.public_ip_addresses
  sensitive = false
}

output "management_api_url" {
  description = "The management_api_url"
  value       = azurerm_api_management.apim.management_api_url
  sensitive = false
}
