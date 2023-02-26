output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
  description = "The vnet resource id"
  sensitive = false
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
  description = "The vnet resource name"
  sensitive = false
}

# output "vnet_subnets" {
#   description = "The ids of subnets created inside the newly created vNet"
#   value       = azurerm_virtual_network.vnet.subnet.*
#   sensitive = false
# }
