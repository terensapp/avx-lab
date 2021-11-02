# AWS Transit Modules

module "aws_transit" {
  for_each =  {for key, value in var.gateways.transit: key => value if value.account == var.accounts.aws}
  source              = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version             = "4.0.1"
  account             = each.value.account
  region              = each.value.region
  name                = each.key
  cidr                = each.value.cidr
  ha_gw               = coalesce(each.value.ha_enabled,false)
  prefix              = false
  suffix              = false
  instance_size       = var.aws_transit_instance_size
  enable_segmentation = true
}

module "aws_spoke" {
  for_each =  {for key, value in var.gateways.spoke: key => value if value.account == var.accounts.aws}
  
  source          = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version         = "4.0.1"
  account         = each.value.account
  region          = each.value.region
  name            = each.key
  cidr            = each.value.cidr
  instance_size   = var.aws_spoke_instance_size
  ha_gw           = coalesce(each.value.ha_enabled,false)
  prefix          = false
  suffix          = false
  attached        = false
  transit_gw      = null
}

resource "aviatrix_spoke_transit_attachment" "attach_gateways" {
  for_each = var.gateways.spoke
  spoke_gw_name   = each.key
  transit_gw_name = each.value.transit

  depends_on = [module.aws_transit, module.aws_spoke]
}