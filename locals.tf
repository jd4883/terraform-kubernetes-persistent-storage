locals {
  size      = format("%sGi", var.size)
  capacity  = { storage = local.size }
  vmdk_path = join("/", [split(".", var.vmdk_path).0, join(".", [var.vmdk_name, "vmdk"])])
  #vsphere_volume_path = format("[%s] %s", vsphere_virtual_disk.disk.datastore, vsphere_virtual_disk.disk.vmdk_path)
}
