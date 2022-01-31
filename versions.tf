terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
  experiments = [module_variable_optional_attrs]
}