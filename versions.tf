terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 1.0"
  experiments = [module_variable_optional_attrs]
}