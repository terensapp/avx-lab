# AWS Transit Modules

# AWS Spoke Modules
#module "aws_spoke_1" {
#  source          = "terraform-aviatrix-modules/aws-spoke/aviatrix"
#  version         = "4.0.1"
#  account         = var.aws_account_name
#  region          = var.aws_spoke1_region
#  name            = var.aws_spoke1_name
#  cidr            = var.aws_spoke1_cidr
#  instance_size   = var.aws_spoke_instance_size
#  ha_gw           = var.ha_enabled
#  prefix          = false
#  suffix          = false
#  transit_gw      = module.aws_transit_1.transit_gateway.gw_name
#}

module "aws_transit" {
  for_each = var.gateways.transit
  source              = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version             = "4.0.1"
  account             = "${lookup(each.value, "account")}"
  region              = "${lookup(each.value, "region")}"
  name                = "${each.key}"
  cidr                = "${lookup(each.value, "cidr")}"
  ha_gw               = var.ha_enabled
  prefix              = false
  instance_size       = var.aws_transit_instance_size
  enable_segmentation = true
}

module "aws_spoke_1" {
  for_each = var.gateways.spoke
  source          = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version         = "4.0.1"
  account         = "${lookup(each.value, "account")}"
  region          = "${lookup(each.value, "region")}"
  name            = "${each.key}"
  cidr            = "${lookup(each.value, "cidr")}"
  instance_size   = var.aws_spoke_instance_size
  ha_gw           = var.ha_enabled
  prefix          = false
  suffix          = false
  transit_gw      = "${lookup(each.value, "transit")}"
}