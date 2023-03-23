locals {
  common_tags = {
    company     = var.company
    project     = "${var.company}-${var.project}"
    environment = terraform.workspace
  }

  sub = substr(data.azurerm_subscription.current.subscription_id, 0, 4)

  name_prefix         = var.naming_prefix
  resource_group_name = lower("rg-${local.name_prefix}-${terraform.workspace}-${var.location}")
  storageAccountName  = lower("sa${local.name_prefix}${terraform.workspace}${var.location}")
  vnet                = lower("vnet-${local.name_prefix}-${terraform.workspace}-${var.location}")
  apim_name           = lower("apim-${local.sub}-${local.name_prefix}-${terraform.workspace}-${var.location}")
  sb_name             = lower("sb-${local.name_prefix}-${terraform.workspace}-${var.location}")
  public_ip           = lower("pip-${local.name_prefix}-${terraform.workspace}-${var.location}")
  # webapp infrustructure
  sp_name             = lower("sp${local.name_prefix}${terraform.workspace}${var.location}")
  api_name            = lower("api-${local.name_prefix}-${terraform.workspace}")
  auth_name           = lower("id-${local.name_prefix}-${terraform.workspace}")
  js_name             = lower("bff-${local.name_prefix}-${terraform.workspace}")
}
