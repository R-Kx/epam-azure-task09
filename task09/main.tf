data "azurerm_resource_group" "rg" {
  name = local.rg_name
}

module "afw" {
  source                  = "./modules/afw"
  unique_id               = var.unique_id
  location                = var.location
  rg_name                 = local.rg_name
  vnet_name               = local.vnet_name
  lb_ip_address           = var.lb_ip_address
  afw_pip_sku             = var.afw_pip_sku
  cidr_block              = var.cidr_block
  afw_nat_action_type     = var.afw_nat_action_type
  public_ip_name          = var.public_ip_name
  afw_sku_name            = var.afw_sku_name
  afw_allocation_method   = var.afw_allocation_method
  subnet_name             = var.subnet_name
  afw_subnet              = var.afw_subnet
  fw_collection_rule_type = var.fw_collection_rule_type
}