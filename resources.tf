resource "vsphere_virtual_disk" "disk" {
  create_directories = var.create_directories
  datacenter         = var.datacenter
  datastore          = var.datastore
  size               = var.size
  type               = var.disk_type
  vmdk_path          = local.vmdk_path
  lifecycle {
    ignore_changes = [
      type,
      datacenter,
      create_directories,
    ]
  }
}

resource "kubernetes_persistent_volume" "pv" {
  metadata { name = var.name }
  spec {
    access_modes                     = var.access_modes
    capacity                         = local.capacity
    mount_options                    = var.mount_options
    persistent_volume_reclaim_policy = var.persistent_volume_reclaim_policy
    volume_mode                      = var.volume_mode
    persistent_volume_source {
      vsphere_volume {
        fs_type     = var.fs_type
        volume_path = local.vsphere_volume_path
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = toset(var.namespaces)
  metadata {
    name      = kubernetes_persistent_volume.pv.metadata.0.name
    namespace = each.value
  }
  spec {
    access_modes = kubernetes_persistent_volume.pv.spec.0.access_modes
    resources { requests = kubernetes_persistent_volume.pv.spec.0.capacity }
  }
}
