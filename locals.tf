locals {
  capacity            = { storage = var.volume.size }
  vmdk_path           = join("/", [split(".", var.volume.vmdk_path).0, join(".", [var.volume.vmdk_name, "vmdk"])])
  size                = tonumber(trimsuffix(var.volume.size, substr(var.volume.size, -2, -1)))
  unit                = substr(var.volume.size, -2, length(var.volume.size))
  unit_capacity       = tonumber(trimsuffix(var.volume.size, substr(var.volume.size, -2, length(var.volume.size))))
  namespaces          = alltrue([(length(var.volume.namespaces) == 0)]) ? [var.volume.name] : var.volume.namespaces
  vsphere_volume_path = format("[%s] %s", vsphere_virtual_disk.disk.datastore, vsphere_virtual_disk.disk.vmdk_path)
}
