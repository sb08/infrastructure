resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    company     = var.company
    project     = "${var.company}-${var.project}"
    environment = terraform.workspace
  }

  name_prefix        = var.naming_prefix
  sp_name            = var.sp_name
  storageAccountName = lower("${local.name_prefix}-sa-${terraform.workspace}")
  vnet               = lower("${local.name_prefix}-vnet-${random_integer.rand.result}-${terraform.workspace}")
  apim_name          = lower("${local.name_prefix}-api-management-${random_integer.rand.result}-${terraform.workspace}")
  sb_name            = lower("${local.name_prefix}-sb-${random_integer.rand.result}-${terraform.workspace}")
  api_name           = lower("${local.name_prefix}-api-${random_integer.rand.result}-${terraform.workspace}")
  auth_name          = lower("${local.name_prefix}-id-${random_integer.rand.result}-${terraform.workspace}")
  js_name            = lower("${local.name_prefix}-js-${random_integer.rand.result}-${terraform.workspace}")
}
