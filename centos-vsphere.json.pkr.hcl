
variable "iso_url" {
  type    = string
  default = "[4TB_Array] iso/CentOS-Stream-8-x86_64-20220215-dvd1.iso"
}

variable "vm-cpu-num" {
  type    = string
  default = "1"
}

variable "vm-disk-size" {
  type    = string
  default = "25600"
}

variable "vm-mem-size" {
  type    = string
  default = "1024"
}

variable "vm-name" {
  type    = string
  #default = "CentOS-Stream-9-Template"
  default = "C9VishalTemplate"
}

variable "vsphere-cluster" {
  type    = string
  default = "Mission Innovation Lab"
}

variable "vsphere-datacenter" {
  type    = string
  default = "Alethix Datacenter"
}

variable "vsphere-datastore" {
  type    = string
  default = "4TB_Array"
}

variable "vsphere-network" {
  type    = string
  default = "VM Network"
}

variable "vsphere-password" {
  type    = string
  default = ""
}

variable "vsphere-server" {
  type    = string
  default = "vcenter.alethixlabs.io"
}

variable "vsphere-user" {
  type    = string
  default = ""
}

source "vsphere-iso" "autogenerated_1" {
  CPUs                 = "${var.vm-cpu-num}"
  RAM                  = "${var.vm-mem-size}"
  RAM_reserve_all      = false
  boot_command         = ["<esc><wait>", "linux ks=hd:fd0:/ks.cfg<enter>"]
  boot_order           = "disk,cdrom,floppy"
  boot_wait            = "10s"
  cluster              = "${var.vsphere-cluster}"
  convert_to_template  = true
  datacenter           = "${var.vsphere-datacenter}"
  datastore            = "${var.vsphere-datastore}"
  disk_controller_type = ["scsi"]
  #disk_size             = "${var.vm-disk-size}"
  #disk_thin_provisioned = true
  storage {
    disk_size             = "${var.vm-disk-size}"
    disk_thin_provisioned = true
  }
  floppy_files        = ["ks.cfg"]
  guest_os_type       = "centos9_64Guest"
  insecure_connection = "true"
  iso_paths           = ["${var.iso_url}"]
  network_adapters {
    network      = "${var.vsphere-network}"
    network_card = "vmxnet3"
  }

  notes          = "Build via Packer"
  password       = "${var.vsphere-password}"
  ssh_password   = "server"
  ssh_username   = "root"
  username       = "${var.vsphere-user}"
  vcenter_server = "${var.vsphere-server}"
  vm_name        = "${var.vm-name}"
}

build {
  sources = ["source.vsphere-iso.autogenerated_1"]

  provisioner "shell" {
    inline = ["sudo rm /etc/machine-id", "sudo touch /etc/machine-id", "echo 'Packer Template Build -- Complete'"]
  }

}
