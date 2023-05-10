data "azurerm_service_plan" "app_sp" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_linux_function_app" "broker_registration" {
  name                = var.broker_reg_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = data.azurerm_service_plan.app_sp.id
  storage_account_name = "storageaccount"

  site_config {}
}