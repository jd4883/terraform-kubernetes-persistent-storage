terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes" }
    local      = { source = "hashicorp/local" }
    vsphere    = { source = "hashicorp/vsphere" }
  }
}
