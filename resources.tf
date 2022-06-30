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
  metadata {
    annotations = { "pv.kubernetes.io/provisioned-by" = "csi.vsphere.vmware.com" }
    name        = var.volume_name
    labels = {
      fcd-id    = var.vmdk_name
      name      = var.name
      namespace = join(",", var.namespaces)
    }
  }
  spec {
    access_modes                     = var.access_modes
    capacity                         = local.capacity
    mount_options                    = var.mount_options
    persistent_volume_reclaim_policy = var.persistent_volume_reclaim_policy
    storage_class_name               = var.storage_class_name
    persistent_volume_source {
      csi {
        driver            = "csi.vsphere.vmware.com"
        volume_handle     = var.volume_handle
        volume_attributes = { type = "vSphere CNS Block Volume" }
      }
    }
  }
  depends_on = [vsphere_virtual_disk.disk]
  lifecycle { ignore_changes = [spec.0.persistent_volume_source.0.csi.0.volume_attributes] }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = toset(var.namespaces)
  metadata {
    name      = var.name
    namespace = each.value
  }
  spec {
    access_modes       = kubernetes_persistent_volume.pv.spec.0.access_modes
    storage_class_name = var.storage_class_name
    volume_name        = kubernetes_persistent_volume.pv.metadata.0.name
    resources { requests = kubernetes_persistent_volume.pv.spec.0.capacity }
    selector { match_labels = { fcd-id = kubernetes_persistent_volume.pv.metadata.0.labels.fcd-id } }
  }
}
