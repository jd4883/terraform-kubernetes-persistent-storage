locals {
  config = merge([for i in module.decoded-config : i.dict]...)
  persistent_volumes = {
    vsphere = { for i in local.config.persistent_volumes : i.name =>
      merge(i, {
        size           = join("", [tonumber(trimsuffix(i.size, substr(i.size, -2, length(i.size)))), substr(i.size, -2, length(i.size))])
        disk_type      = lookup(i, "disk_type", "eagerZeroedThick")
        read_only      = lookup(i, "read_only", false)
        reclaim_policy = lookup(i, "reclaim_policy", "Retain")
    }) if !contains(lookup(i, "access_modes", ["ReadWriteOnce"]), "ReadWriteMany") }
    nfs = { for i in local.config.persistent_volumes : i.name => {
      access_modes   = lookup(i, "access_modes", ["ReadWriteOnce"])
      capacity       = tonumber(trimsuffix(i.size, substr(i.size, -2, length(i.size))))
      name           = i.name
      namespaces     = lookup(i, "namespaces", [i.name])
      path           = i.path
      read_only      = lookup(i, "read_only", false)
      reclaim_policy = lookup(i, "reclaim_policy", "Retain")
      server         = "172.16.11.246"
      unit           = substr(i.size, -2, length(i.size))
      volume_mode    = lookup(i, "volume_mode", "Filesystem")
    } if contains(lookup(i, "access_modes", ["ReadWriteOnce"]), "ReadWriteMany") }
  }
  volumes = {
    nfs = { for k, v in module.parser-nfs : k => v.volume }
  }
  credentials = {
    lastpass = { (local.config.vcenter.hostname) : local.config.vcenter.lastpass }
  }
  domain = {
    internal = local.config.domain.internal
    external = local.config.domain.external
  }
  globals = {
    allow_unverified_ssl = !can(local.config.shared.allow_unverified_ssl)
    lastpass = {
      username = local.config.lastpass.username
      password = sensitive(local.config.lastpass.password)
    }
  }
  vcenter = {
    fqdn = join(".", [local.config.vcenter.hostname, local.domain.internal])
    users = {
      base = {
        username = module.credentials[local.config.vcenter.hostname].username
        password = module.credentials[local.config.vcenter.hostname].password
      }
      root = {
        username = "root"
        password = module.credentials[local.config.vcenter.hostname].password
      }
    }
  }
}
