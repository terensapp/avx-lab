provider "aviatrix" {
  controller_ip = var.controller_ip
  username      = var.username
  password      = var.password
}

# provider definitions
provider "aws" {
    alias   = "us-east-1"
    region  = "us-east-1"
}

provider "aws" {
    alias   = "us-east-2"
    region  = "us-east-2"
}

provider "aws" {
    alias   = "us-west-1"
    region  = "us-west-1"
}

provider "aws" {
    alias   = "ohio"
    region  = "us-west-2"
}