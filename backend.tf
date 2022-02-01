terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "terensapp"
    workspaces {
      name = "avx-mcna"
    }
  }
}