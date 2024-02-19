variable "volume" {
  type = object(
    {
      access_modes                     = optional(list(string), ["ReadWriteOnce"])
      annotations                      = optional(map(string), {})
      create_directories               = optional(bool, true)
      csi_driver                       = optional(string, "csi.vsphere.vmware.com")
      datacenter                       = optional(string, null)
      datastore                        = string
      disk_type                        = optional(string, "eagerZeroedThick")
      fs_type                          = optional(string, "ext4")
      labels                           = optional(map(string), {})
      mount_options                    = optional(list(string), null)
      name                             = string
      namespaces                       = optional(list(string), [])
      persistent_volume_reclaim_policy = optional(string, "Retain")
      read_only                        = optional(bool, false)
      size                             = string
      storage_class                    = string
      vmdk_name                        = string
      vmdk_path                        = string
      volume_attributes                = optional(map(string), { type = "vSphere CNS Block Volume" })
      volume_handle                    = optional(string, null)
      volume_mode                      = optional(string, "Filesystem")
      volume_name                      = string
    }
  )
}
