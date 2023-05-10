output "broker-registration-messagedb" {
  value = azurerm_cosmosdb_account.messagedb.name
  description = "The broker registration MongoDb name"
  sensitive = false
}
