#output "total_provisioned_disk_space" { value = format("%s GB", ceil(sum([for i in local.persistent_volumes.vsphere : i.unit == "Gi" ? i.capacity : i.capacity / 1024]))) }
output "total_provisioned_disk_space" { value = format("%s GB", ceil(sum([for i in values(module.storage) : i.unit == "Gi" ? i.capacity : i.capacity / 1024]))) }


#
#output "configs" { value = format("%s GB", ceil(sum([for i in local.persistent_volumes.vsphere : i.unit == "Gi" ? i.capacity : i.capacity / 1024 if endswith(i.name, "-config")]))) }
output "configs" { value = format("%s GB", ceil(sum([for i in values(module.storage) : i.unit == "Gi" ? i.capacity : i.capacity / 1024 if endswith(i.name, "-config")]))) }
