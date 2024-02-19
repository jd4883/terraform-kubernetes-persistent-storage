provider "kubernetes" {
  config_path    = var.kuernetes_config_path
  config_context = local.config.cluster.name
}

provider "lastpass" {
  username = local.globals.lastpass.username
  password = local.globals.lastpass.password
}

provider "vsphere" {
  user                 = local.vcenter.users.base.username
  password             = local.vcenter.users.base.password
  vsphere_server       = local.vcenter.fqdn
  allow_unverified_ssl = local.globals.allow_unverified_ssl
}
