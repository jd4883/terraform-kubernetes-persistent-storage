terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes" }
    lastpass   = { source = "nrkno/lastpass" }
    local      = { source = "hashicorp/local" }
    vsphere    = { source = "hashicorp/vsphere" }
  }
  backend "s3" {
    bucket = "home-lab-terraform-state"
    key    = "k8s/persistent-volumes.tfstate"
    region = "us-west-2"
  }
}
