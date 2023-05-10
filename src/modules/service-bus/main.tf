resource "azurerm_servicebus_namespace" "sb" {
  name                = var.sb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags = var.common_tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "authRule" {
  name                = "messagebus-policy"
  namespace_id = azurerm_servicebus_namespace.sb.id
  listen              = true
  send                = true
  manage              = true
    depends_on = [
    azurerm_servicebus_namespace.sb
  ]
}

resource "azurerm_servicebus_topic" "sbRegistrationTopic" {
  name                = "registration"
  namespace_id = azurerm_servicebus_namespace.sb.id
  enable_partitioning = true
}

resource "azurerm_servicebus_subscription" "sbRegistrationSubscription" {
  name                = "registration"
  topic_id          = azurerm_servicebus_topic.sbRegistrationTopic.id
  max_delivery_count  = 1
}

data "azurerm_api_management" "apim" {
  name                = var.apim_name
  resource_group_name = var.resource_group_name
}

data "external" "generate-servicebus-sas" {
  program = ["Powershell.exe", "Set-ExecutionPolicy Bypass -Scope Process -Force; C://bitbucket//infrastructure//gensas.ps1"]

  query = {
    servicebusUri = "${azurerm_servicebus_namespace.sb.name}.servicebus.windows.net"
    sbName        = azurerm_servicebus_namespace.sb.name
    policyName    = "messagebus-policy"
    policyKey     = azurerm_servicebus_namespace_authorization_rule.authRule.primary_key
    sasExpiresInSeconds = 5256000
  }
}

# Create an apim api which sends a message to service bus.
resource "azurerm_api_management_api" "registration" {
  name                = "service-bus"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "servicebus-direct"
  path                = "service-bus"
  protocols           = ["https"]
  subscription_required = false
  description         = "registration request direct to service bus."
  service_url         = "https://${azurerm_servicebus_namespace.sb.name}.servicebus.windows.net"
  import {
    content_format = "openapi+json"
    content_value  = "${jsonencode(
    {
      "openapi": "3.0.1",
      "info": {
          "title": "apim to servicebus",
          "description": "",
          "version": "1.0"
      },
      "servers": [
          {
              "url": "${data.azurerm_api_management.apim.gateway_url}/service-bus"
          }
      ],
      "paths": {
          "/registration": {
              "post": {
                  "summary": "to registration topic",
                  "operationId": "post-to-registration-topic",
                  "responses": {
                      "202": {
                          "description": null
                      }
                  }
              }
          }
      },
      "components": {
          "securitySchemes": {
              "apiKeyHeader": {
                  "type": "apiKey",
                  "name": "Ocp-Apim-Subscription-Key",
                  "in": "header"
              },
              "apiKeyQuery": {
                  "type": "apiKey",
                  "name": "subscription-key",
                  "in": "query"
              }
          }
      },
      "security": [
          {
              "apiKeyHeader": []
          },
          {
              "apiKeyQuery": []
          }
      ]
      })}"
  }
}

resource "azurerm_api_management_api_policy" "apiPolicy" {
  api_name            = "service-bus"
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name

  xml_content = <<-XML
    <policies>
        <inbound>
            <base />
            <set-header name="Content-Type" exists-action="override">
                <value>application/atom+xml;type=entry;charset=utf-8</value>
            </set-header>
            <set-header name="Authorization" exists-action="override">
               <value>@((string)"${data.external.generate-servicebus-sas.result.sas}")</value>
            </set-header>
        </inbound>
        <backend>
            <forward-request />
        </backend>
        <outbound>
            <base />
        </outbound>
        <on-error>
            <base />
        </on-error>
    </policies>
  XML
}
# todo: add through portal after deployment
# <set-header name="Authorization" exists-action="override">
#     <value>@((string)"${data.external.generate-servicebus-sas.result.sas}")</value>
# </set-header>

resource "azurerm_api_management_api_operation_policy" "operationPolicyRegistration" {
  api_name            = "service-bus"
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  operation_id        = "post-to-registration-topic"

  xml_content = <<-XML
    <policies>
        <inbound>
            <base />
            <rewrite-uri template="/registration/messages" />
        </inbound>
        <backend>
            <forward-request />
        </backend>
        <outbound>
            <base />
        </outbound>
        <on-error>
            <base />
        </on-error>
    </policies>
  XML
}
