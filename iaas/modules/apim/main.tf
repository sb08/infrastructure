data "azurerm_subnet" "apim" {
  name                 = var.subnet
  virtual_network_name = var.vnet
  resource_group_name  = var.resource_group_name
}

resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "TechOps"
  publisher_email     = "sboulter@latrobefinancial.com.au"
  notification_sender_email     = "sboulter@latrobefinancial.com.au"
  sku_name            = "Developer_1"
  virtual_network_type      = var.virtual_network_type
  public_ip_address_id = var.public_ip_address_id
  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.apim.id
}
  tags = var.common_tags
#   policy {
#     xml_content = <<XML
#     <policies>
#     <inbound>
#         <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
#             <openid-config url="https://ltf-id-42901-dev.azurewebsites.net/.well-known/openid-configuration" />
#             <required-claims>
#                 <claim name="aud">
#                     <value>{"apim"}</value>
#                 </claim>
#             </required-claims>
#         </validate-jwt>
#       </inbound>
#       <backend />
#       <outbound />
#       <on-error />
#     </policies>
# XML
#   }
}

# resource "azurerm_api_management_backend" "backend" {
#   name                = "apim-backend"
#   resource_group_name = var.resource_group_name
#   api_management_name = azurerm_api_management.apim.name
#   protocol            = "http"
#   url                 = "https://backend"
# }
