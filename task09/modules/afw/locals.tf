locals {
  pub_ip       = format("%s-afw-pip", var.unique_id)
  afw_name     = format("%s-afw", var.unique_id)
  rt_name      = format("%s-rt", var.unique_id)
  afw_app_rule = format("%s-afw-app-rule", var.unique_id)
  afw_net_rule = format("%s-afw-net-rule", var.unique_id)
  afw_nat_rule = format("%s-afw-nat-rule", var.unique_id)
}