data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_public_ip" "public_ip_addr" {
  name                = local.public_ip
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  domain_name_label   = local.public_ip
  tags                = local.common_tags
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_network_security_group" "apim_sg" {
  name                = lookup(var.nsg_ids, "apim", "apim-sg")
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "nsg-config" {
  source              = "./modules/nsg-config"
  nsg_name            = lookup(var.nsg_ids, "apim", "apim_sg")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  common_tags         = local.common_tags
  depends_on = [
    azurerm_network_security_group.apim_sg
  ]
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "3.0.0"
  vnet_name           = local.vnet
  vnet_location       = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_cidr_range
  nsg_ids = {
    apim = azurerm_network_security_group.apim_sg.id
  }
  subnet_names    = var.subnet_names
  subnet_prefixes = var.subnets
  subnet_service_endpoints = {
    apim = ["Microsoft.EventHub", "Microsoft.Sql", "Microsoft.Storage"]
  }
  #private_endpoint_network_policies_enabled
  # subnet_enforce_private_link_service_network_policies = {
  #   "sbus" = true
  # }
  tags       = local.common_tags
  depends_on = [azurerm_resource_group.rg, module.nsg-config]
}

module "apim" {
  source               = "./modules/apim"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  apim_name            = local.apim_name
  common_tags          = local.common_tags
  vnet                 = module.vnet.vnet_name
  subnet               = var.subnet_names[0]
  public_ip_address_id = azurerm_public_ip.public_ip_addr.id
  depends_on           = [module.vnet, azurerm_public_ip.public_ip_addr]
}

module "sb" {
  source              = "./modules/service-bus"
  sb_name             = local.sb_name
  apim_name           = local.apim_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  common_tags         = local.common_tags
  depends_on          = [module.apim]
}

# module "apps" {
#   source                = "./modules/apps"
#   app_service_plan_name = local.sp_name
#   auth_name             = local.auth_name
#   api_name              = local.api_name
#   js_name               = local.js_name
#   resource_group_name   = azurerm_resource_group.rg.name
#   location              = azurerm_resource_group.rg.location
#   common_tags           = local.common_tags
#   sku_name              = var.sku_name
#   sb_name               = local.sb_name
#   apim_name             = local.apim_name
#   depends_on            = [module.apim]
# }
