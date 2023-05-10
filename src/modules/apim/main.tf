data "azurerm_subnet" "apim" {
  name                = "apim"
  virtual_network_name = var.vnet
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "TechOps"
  publisher_email     = "sboulter@latrobefinancial.com.au"
  notification_sender_email     = "sboulter@latrobefinancial.com.au"
  sku_name            = "Developer_1"
  identity {
    type = "SystemAssigned"
  }
  virtual_network_type      = var.virtual_network_type
  public_ip_address_id = var.public_ip_address_id
  virtual_network_configuration {
      subnet_id = data.azurerm_subnet.apim.id
  }
  tags = var.common_tags
  policy {
    xml_content = <<XML
    <policies>
    <inbound>
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
            <openid-config url="https://${var.auth_name}.azurewebsites.net/.well-known/openid-configuration" />
            <required-claims>
            <claim name="aud" match="any">
                <value>apim</value>
            </claim>
            <claim name="scope" match="any">
                <value>apim</value>
            </claim>
            </required-claims>
        </validate-jwt>
      </inbound>
      <backend>
          <forward-request />
      </backend>
      <outbound />
      <on-error />
    </policies>
XML
  }
}

# ####################this errored
# resource "azurerm_api_management_user" "user1" {
#   user_id             = "1"
#   api_management_name = var.apim_name
#   resource_group_name = var.resource_group_name
#   first_name          = "Stephen"
#   last_name           = "Boulter"
#   email               = "stephen.boulter@outlook.com"
#   state               = "active"
# }

# resource "azurerm_api_management_notification_recipient_user" "publisher_notification" {
#   api_management_id = azurerm_api_management.apim.id
#   notification_type = "RequestPublisherNotificationMessage"
#   user_id           = azurerm_api_management_user.user1.user_id
# }

# resource "azurerm_api_management_notification_recipient_user" "app_notification" {
#   api_management_id = azurerm_api_management.apim.id
#   notification_type = "NewApplicationNotificationMessage"
#   user_id           = azurerm_api_management_user.user1.user_id
# }
# ####################this errored

resource "azurerm_api_management_api" "api" {
  api_management_name = var.apim_name
  name                = "broker-registration"
  display_name = "Broker Registration"
  resource_group_name = var.resource_group_name
  revision            = "1"
  path = "broker"
  protocols           = ["https"]
  subscription_required = false
  service_url = "https://${var.api_name}.azurewebsites.net"
  depends_on = [
    azurerm_api_management.apim
  ]
  import {
    content_format = "openapi+json-link"
    content_value  = "https://${var.api_name}.azurewebsites.net/swagger/v1/swagger.json\n\n"
  }
}

# resource "azurerm_api_management_product" "product" {
#   product_id            = var.product.productId
#   api_management_name   = azurerm_api_management.apim.name
#   resource_group_name   = var.resource_group_name
#   display_name          = var.product.productName
#   subscription_required = var.product.subscriptionRequired
#   subscriptions_limit   = var.product.subscriptionsLimit
#   approval_required     = var.product.approvalRequired
#   published             = var.product.published
# }
# assign policy to product
# resource "azurerm_api_management_product_policy" "productPolicy" {
#   product_id          = var.product.productId
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name = azurerm_resource_group.rg.name
#   xml_content = <<XML
#     <policies>
#       <inbound>
#         <base />
#       </inbound>
#       <backend>
#         <base />
#       </backend>
#       <outbound>
#         <set-header name="Server" exists-action="delete" />
#         <set-header name="X-Powered-By" exists-action="delete" />
#         <set-header name="X-AspNet-Version" exists-action="delete" />
#         <base />
#       </outbound>
#       <on-error>
#         <base />
#       </on-error>
#     </policies>
# XML
#   depends_on = [azurerm_api_management_product.product]
# }

resource "azurerm_api_management_api" "apiHealthProbe" {
name                = "health-probe"
  resource_group_name = var.resource_group_name
api_management_name = azurerm_api_management.apim.name
revision            = "1"
display_name        = "Health probe"
path                = "health-probe"
protocols           = ["https"]

  subscription_key_parameter_names  {
    header = "AppKey"
    query = "AppKey"
  }

  import {
    content_format = "swagger-json"
    content_value  = <<JSON
      {
          "swagger": "2.0",
          "info": {
              "version": "1.0.0",
              "title": "Health probe"
          },
          "host": "not-used-direct-response",
          "basePath": "/",
          "schemes": [
              "https"
          ],
          "consumes": [
              "application/json"
          ],
          "produces": [
              "application/json"
          ],
          "paths": {
              "/": {
                  "get": {
                      "operationId": "get-ping",
                      "responses": {}
                  }
              }
          }
      }
JSON
  }
}

resource "azurerm_api_management_api_policy" "apiHealthProbePolicy" {
  api_name            = azurerm_api_management_api.apiHealthProbe.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
    <policies>
      <inbound>
        <return-response>
            <set-status code="200" />
        </return-response>
        <base />
      </inbound>
    </policies>
XML
}

# resource "azurerm_api_management_product_api" "apiProduct" {
#   api_name            = azurerm_api_management_api.apiHealthProbe.name
#   product_id          = azurerm_api_management_product.product.product_id
#   api_management_name = azurerm_api_management.apim.name
#   resource_group_name = var.resource_group_name
# }
