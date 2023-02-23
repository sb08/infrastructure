# resource "random_integer" "rand" {
#   min = 1000
#   max = 9999
# }

locals {
  common_tags = {
    company     = var.company
    project     = "${var.company}-${var.project}"
    environment = terraform.workspace
  }

  # random_integer      = random_integer.rand.result
  name_prefix         = var.naming_prefix
  resource_group_name = lower("rg-${local.name_prefix}-${terraform.workspace}-${var.location}")
  storageAccountName  = lower("sa${local.name_prefix}${terraform.workspace}${var.location}")
  vnet                = lower("vnet-${local.name_prefix}-${terraform.workspace}-${var.location}")
  apim_name           = lower("apim-${local.name_prefix}-${terraform.workspace}-${var.location}")
  sb_name             = lower("sb-${local.name_prefix}-${terraform.workspace}-${var.location}")
  public_ip           = lower("publicip-${local.name_prefix}-${terraform.workspace}-${var.location}")
}
