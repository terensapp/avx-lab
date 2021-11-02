# AWS Transit Modules

module "aws_transit" {
  for_each = var.gateways.transit
  source              = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version             = "4.0.1"
  account             = "${lookup(each.value, "account")}"
  region              = "${lookup(each.value, "region")}"
  name                = "${each.key}"
  cidr                = "${lookup(each.value, "cidr")}"
  ha_gw               = coalesce("${lookup(each.value, "ha_enabled")}",false)
  prefix              = false
  suffix              = false
  instance_size       = var.aws_transit_instance_size
  enable_segmentation = true
}

module "aws_spoke" {
  for_each = var.gateways.spoke
  source          = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version         = "4.0.1"
  account         = "${lookup(each.value, "account")}"
  region          = "${lookup(each.value, "region")}"
  name            = "${each.key}"
  cidr            = "${lookup(each.value, "cidr")}"
  instance_size   = var.aws_spoke_instance_size
  ha_gw           = coalesce("${lookup(each.value, "ha_enabled")}",false)
  prefix          = false
  suffix          = false
  #transit_gw      = "${lookup(each.value, "transit")}"

  #depends_on = [module.aws_transit]
}

resource "aviatrix_spoke_transit_attachment" "test_attachment" {
  for_each = var.gateways.spoke
  spoke_gw_name   = "${each.key}"
  transit_gw_name = "${lookup(each.value, "transit")}"

  depends_on = [module.aws_transit, module.aws_spoke]
}