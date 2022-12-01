data "azurerm_network_security_group" "apim_sg" {
  name                = var.nsg_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "rule-1" {
  access                      = "Allow"
  description                 = "Client communication to API Management"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_ranges     = ["80", "443"]
  direction                   = "Inbound"
  name                        = "InboundTcpInternet"
  network_security_group_name = data.azurerm_network_security_group.apim_sg.name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "Internet"
  source_port_range           = "*"
  # depends_on = [
  #   azurerm_network_security_group.apim_sg
  # ]
}

# resource "azurerm_network_security_rule" "rule-2" {
#   access                      = "Allow"
#   destination_address_prefix  = "VirtualNetwork"
#   destination_port_range      = "6381-6383"
#   direction                   = "Inbound"
#   name                        = "Dependency_on_Redis_Cache"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 150
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg,
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-3" {
#   access                      = "Allow"
#   destination_address_prefix  = "VirtualNetwork"
#   destination_port_range      = "4290"
#   direction                   = "Inbound"
#   name                        = "Dependency_to_sync_Rate_Limit_Inbound"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 200
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg,
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-4" {
#   access                      = "Allow"
#   destination_address_prefix  = "VirtualNetwork"
#   destination_port_range      = "6390"
#   direction                   = "Inbound"
#   name                        = "Azure_Infrastructure_Load_Balancer"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 250
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "AzureLoadBalancer"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg,
#   # ]
# }

resource "azurerm_network_security_rule" "rule-5" {
  access                      = "Allow"
  description                 = "Management endpoint for Azure portal and PowerShell"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_ranges     = ["3443"]
  direction                   = "Inbound"
  name                        = "InboundApiManagement"
  network_security_group_name = data.azurerm_network_security_group.apim_sg.name
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "ApiManagement"
  source_port_range           = "*"
  # depends_on = [
  #   azurerm_network_security_group.apim_sg
  # ]
}

# required for Premium service tier
resource "azurerm_network_security_rule" "rule-6" {
  access                      = "Allow"
  description                 = "Azure Infrastructure Load Balancer"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_ranges     = ["6390"]
  direction                   = "Inbound"
  name                        = "InboundLoadBalancer"
  network_security_group_name = data.azurerm_network_security_group.apim_sg.name
  priority                    = 350
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "AzureLoadBalancer"
  source_port_range           = "*"
  # depends_on = [
  #   azurerm_network_security_group.apim_sg
  # ]
}

resource "azurerm_network_security_rule" "rule-7" {
  access                      = "Allow"
  description                 = "Dependency on Azure Storage"
  destination_address_prefix  = "Storage"
  destination_port_ranges     = ["443"]
  direction                   = "Outbound"
  name                        = "Azure_Storage"
  network_security_group_name = data.azurerm_network_security_group.apim_sg.name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  # depends_on = [
  #   azurerm_network_security_group.apim_sg
  # ]
}

resource "azurerm_network_security_rule" "rule-8" {
  access                      = "Allow"
  description                 = "Access to Azure SQL endpoints"
  destination_address_prefix  = "SQL"
  destination_port_ranges     = ["1433"]
  direction                   = "Outbound"
  name                        = "OutboundSql"
  network_security_group_name = data.azurerm_network_security_group.apim_sg.name
  priority                    = 150
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  # depends_on = [
  #   azurerm_network_security_group.apim_sg
  # ]
}

# resource "azurerm_network_security_rule" "rule9" {
#   access                      = "Allow"
#   destination_address_prefix  = "EventHub"
#   destination_port_range      = "5671"
#   direction                   = "Outbound"
#   name                        = "Dependency_for_Log_to_event_Hub_policy"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 200
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-10" {
#   access                      = "Allow"
#   destination_address_prefix  = "VirtualNetwork"
#   destination_port_range      = "6381-6383"
#   direction                   = "Outbound"
#   name                        = "Dependency_on_Redis_Cache_outbound"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 250
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-11" {
#   access                      = "Allow"
#   destination_address_prefix  = "VirtualNetwork"
#   destination_port_range      = "4290"
#   direction                   = "Outbound"
#   name                        = "Depenedency_To_sync_RateLimit_Outbound"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 300
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-12" {
#   access                      = "Allow"
#   destination_address_prefix  = "Storage"
#   destination_port_range      = "445"
#   direction                   = "Outbound"
#   name                        = "Dependency_on_Azure_File_Share_for_GIT"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 350
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-13" {
#   access                      = "Allow"
#   description                 = "API Management logs and metrics for consumption by admins and your IT team are all part of the management plane"
#   destination_address_prefix  = "AzureMonitor"
#   destination_port_ranges     = ["12000", "1886", "443"]
#   direction                   = "Outbound"
#   name                        = "Publish_DiagnosticLogs_And_Metrics"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 400
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-14" {
#   access                      = "Allow"
#   description                 = "APIM features the ability to generate email traffic as part of the data plane and the management plane"
#   destination_address_prefix  = "Internet"
#   destination_port_ranges     = ["25", "25028", "587"]
#   direction                   = "Outbound"
#   name                        = "Connect_To_SMTP_Relay_For_SendingEmails"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 450
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-15" {
#   access                      = "Allow"
#   description                 = "Connect to Azure Active Directory for developer Portal authentication or for OAuth 2 flow during any proxy authentication"
#   destination_address_prefix  = "AzureActiveDirectory"
#   destination_port_ranges     = ["443", "80"]
#   direction                   = "Outbound"
#   name                        = "Authenticate_To_Azure_Active_Directory"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 500
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-16" {
#   access                      = "Allow"
#   description                 = "API Management logs and metrics for consumption by admins and your IT team are all part of the management plane"
#   destination_address_prefix  = "AzureMonitor"
#   destination_port_ranges     = ["12000", "1886", "443"]
#   direction                   = "Outbound"
#   name                        = "Publish_DiagnosticLogs_And_Metrics"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 550
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_network_security_rule" "rule-17" {
#   access                      = "Allow"
#   description                 = "Connect to Azure Active Directory for developer Portal authentication or for OAuth 2 flow during any proxy authentication"
#   destination_address_prefix  = "AzureActiveDirectory"
#   destination_port_ranges     = ["443", "80"]
#   direction                   = "Outbound"
#   name                        = "Authenticate_To_Azure_Active_Directory"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 600
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg,
#   # ]
# }

resource "azurerm_network_security_rule" "rule-18" {
  access                      = "Allow"
  description                 = "Allow API Management service control plane access to Azure Key Vault to refresh secrets"
  destination_address_prefix  = "AzureKeyVault"
  destination_port_ranges     = ["433"]
  direction                   = "Outbound"
  name                        = "Access_KeyVault"
  network_security_group_name = data.azurerm_network_security_group.apim_sg.name
  priority                    = 650
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  # depends_on = [
  #   azurerm_network_security_group.apim_sg
  # ]
}

# resource "azurerm_network_security_rule" "rule-999" {
#   access                      = "Deny"
#   destination_address_prefix  = "Internet"
#   destination_port_range      = "*"
#   direction                   = "Outbound"
#   name                        = "Deny_All_Internet_Outbound"
#   network_security_group_name = data.azurerm_network_security_group.apim_sg.name
#   priority                    = 999
#   protocol                    = "Tcp"
#   resource_group_name         = var.resource_group_name
#   source_address_prefix       = "VirtualNetwork"
#   source_port_range           = "*"
#   # depends_on = [
#   #   azurerm_network_security_group.apim_sg
#   # ]
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = "${var.vnet_name}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   address_space       = ["10.0.0.0/16"]
  # dns_servers         = ["10.0.0.4", "10.0.0.5"]
  # subnet {
  #   name           = "subnet1"
  #   address_prefix = "10.0.1.0/24"
  # }
  #
  # subnet {
  #   name           = "apim"
  #   address_prefix = "10.0.2.0/24"
  #   security_group = azurerm_network_security_group.apim_sg.id
  # }
  #
  # subnet {
  #   name           = "subnet3"
  #   address_prefix = "10.0.3.0/24"
  #   security_group = azurerm_network_security_group.apim_sg.id
  # }

#   tags = var.common_tags
# }

# resource "azurerm_subnet" "apim" {
#   name                 = "apim"
#   resource_group_name = var.resource_group_name
#   address_prefixes     = ["10.0.1.0/24"]
#   depends_on = [
#     azurerm_virtual_network.vnet
#   ]
# }

# resource "azurerm_subnet" "apps" {
#   name                 = "apps"
#   resource_group_name = var.resource_group_name
#   address_prefixes     = ["10.0.2.0/24"]
#   virtual_network_name = azurerm_virtual_network.vnet.name
#
#   depends_on = [
#     azurerm_virtual_network.vnet
#   ]
# }

# resource "azurerm_subnet_network_security_group_association" "sg_association" {
#   subnet_id                 = azurerm_subnet.apim.id
#   network_security_group_id = azurerm_network_security_group.apim_sg.id
# }
