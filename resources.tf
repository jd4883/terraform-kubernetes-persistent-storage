resource "vsphere_virtual_disk" "disk" {
  create_directories = var.volume.create_directories
  datacenter         = var.volume.datacenter
  datastore          = var.volume.datastore
  size               = local.size
  type               = var.volume.disk_type
  vmdk_path          = local.vmdk_path
  lifecycle {
    ignore_changes = [
      create_directories,
      datacenter,
      size, # necessary for volumes smaller than 1 gig
      type,
    ]
  }
}

resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = var.volume.volume_name
    labels = {
      fcd-id    = var.volume.vmdk_name
      name      = var.volume.name
      namespace = join(",", local.namespaces)
    }
  }
  spec {
    access_modes                     = var.volume.access_modes
    capacity                         = local.capacity
    mount_options                    = var.volume.mount_options
    persistent_volume_reclaim_policy = var.volume.persistent_volume_reclaim_policy
    storage_class_name               = var.volume.storage_class
    dynamic "claim_ref" {
      for_each = toset(local.namespaces)
      content {
        name      = var.volume.name
        namespace = claim_ref.value
      }
    }
    persistent_volume_source {
      csi {
        driver            = var.volume.csi_driver
        fs_type           = var.volume.fs_type
        read_only         = var.volume.read_only
        volume_handle     = var.volume.volume_handle
        volume_attributes = var.volume.volume_attributes
      }
    }
  }
  depends_on = [vsphere_virtual_disk.disk]
  lifecycle { ignore_changes = [spec.0.persistent_volume_source.0.csi.0.volume_attributes] }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = toset(local.namespaces)
  metadata {
    annotations = var.volume.annotations
    labels      = var.volume.labels
    name        = var.volume.name
    namespace   = each.value
  }
  spec {
    access_modes       = kubernetes_persistent_volume.pv.spec.0.access_modes
    storage_class_name = kubernetes_persistent_volume.pv.spec.0.storage_class_name
    volume_name        = kubernetes_persistent_volume.pv.metadata.0.name
    resources { requests = kubernetes_persistent_volume.pv.spec.0.capacity }
    selector { match_labels = { fcd-id = kubernetes_persistent_volume.pv.metadata.0.labels.fcd-id } }
  }
}
