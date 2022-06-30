variable "access_modes" { type = list(string) }
variable "datastore" { type = string }
variable "name" { type = string }
variable "namespaces" { type = list(string) }
variable "size" { type = number }
variable "storage_class_name" { type = string }
variable "vmdk_name" { type = string }
variable "vmdk_path" { type = string }
variable "volume_name" { type = string }

variable "volume_handle" {
  default = null
  type    = string
}

variable "create_directories" {
  default = true
  type    = bool
}

variable "datacenter" {
  default = null
  type    = string
}

variable "disk_type" {
  default = "eagerZeroedThick"
  type    = string
}

variable "fs_type" {
  default = "ext4"
  type    = string
}

variable "mount_options" {
  default = []
  type    = list(string)
}

variable "persistent_volume_reclaim_policy" {
  default = "Retain"
  type    = string
}

variable "volume_mode" {
  default = "Filesystem"
  type    = string
}
