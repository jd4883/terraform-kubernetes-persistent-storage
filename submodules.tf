module "decoded-config" {
  for_each  = fileset("${path.root}/configs", "*.yaml")
  source    = "jd4883/dict-converter-yaml/yaml"
  filename  = split(".", each.value).0
  extension = split(".", each.value).1
}

module "parser-nfs" {
  source   = "./modules/parser-nfs"
  for_each = local.persistent_volumes.nfs
  input    = each.value
}

module "storage" {
  source   = "./modules/storage" #"jd4883/persistent-storage/kubernetes"
  for_each = local.persistent_volumes.vsphere
  volume   = each.value
}

module "nfs" {
  source                           = "./modules/nfs"
  for_each                         = local.volumes.nfs
  access_modes                     = each.value.access_modes
  name                             = each.value.name
  namespaces                       = each.value.namespaces
  nfs                              = each.value.nfs
  persistent_volume_reclaim_policy = each.value.reclaim_policy
  size                             = each.value.size
  volume_mode                      = each.value.volume_mode
}

module "credentials" {
  for_each = local.credentials.lastpass
  source   = "jd4883/credential-helper/lastpass"
  secret   = each.value
}
