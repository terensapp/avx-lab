variable "username" {
  default = "admin"
}

variable "password" {
}

variable "controller_ip" {
}

variable "host_password" {
}

variable "aws_account_name" {
}

variable "defaultregion" {
  default = "us-east-2"
}

variable "aws_transit_instance_size" {
  default = "t3.micro"
}

variable "aws_spoke_instance_size" {
  default = "t3.micro"
}

variable "aws_test_instance_size" {
  default = "t2.micro"
}

variable "azure_account_name" {
}

variable "azure_spoke_instance_size" {
  default = "Standard_B1ms"
}

variable "azure_transit_instance_size" {
  default = "Standard_B1ms"
}

variable "azure_spoke2_region" {
  default = "Canada Central"
}

variable "azure_spoke2_name" {
  default = "azure-spoke2"
}

variable "azure_spoke2_cidr" {
  default = "10.1.212.0/24"
}

variable "azure_test_instance_size" {
  default = "Standard_B1ms"
}

variable "ec2_key_name" {
  default = "avx-terenmbp"
}

variable "ec2_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChIIrztgoVUiIdH5OYS0CCD9zjmQNs7GWs/xfrAd+5UkaeUW46V8kP7IQ9TZVrPJs2i1mscOTDEccIVlqczCM5eOnRn8163H+kxOZTsRbF3LsgmktqrzGQHx67ftNO01cfrfVR0oxK37poxpIsa4KoLeZfa7xjey9AL4jQYlRH7Lc/K972BdaBB71bjpsLc8hZHjd+ZXa0igJWaSVlzeqKStMq1PfyTdcqoVghTL1t7G1VvJYFW0vr4picuoUIZGw8+x4AlLseXtiXEkGKx/sOjYYRmd2P4B8nKJBfi7TXZ8bZZypeJ4Anf3D+AgzLmlgU95bJdjcV3AObI6PriXrnVjFJ1XPj5g36HHUt6vuHfv4DzH+ohZvcdrPOu5XmPVe91GwKXw4KZX8IH5sU9c2RfZm/o1AYM1RLg6gHwtZf53tkOyECZpIE5HMxYXqLhUgONpkbZjFWHc5wi20sUyYk/jjVpvp52d12g2be42REeAmim6T+yQmcu1Z+yMlBHiE= terensapp@Teren-Sapps-MacBook-Pro.local"
}

variable "accounts" {
  type = object({
        aws = optional(string)
        azure = optional(string)
        gcloud = optional(string)
      })
}

variable "gateways" {
  type = map(map(object({
        account = string
        region = string
        cidr = string
        transit = optional(string)
        ha_enabled = optional(bool)
        attach_host = optional(bool)
      })))
}