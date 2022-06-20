locals {
  size                = format("%sGi", var.size)
  capacity            = { storage = local.size }
  vmdk_path           = join("/", [split(".", var.vmdk_path).0, var.vmdk_name])
  vsphere_volume_path = format("[%s] %s", vsphere_virtual_disk.disk.datastore, vsphere_virtual_disk.disk.vmdk_path)
}
