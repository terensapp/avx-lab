provider "aviatrix" {
  controller_ip = var.AVIATRIX_CONTROLLER_IP
  username      = var.AVIATRIX_USERNAME
  password      = var.AVIATRIX_PASSWORD
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

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
    alias   = "us-west-2"
    region  = "us-west-2"
}