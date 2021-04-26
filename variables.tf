variable "prefix" {
  description = "The Prefix used for all VM resources"
  default = "tf_vm"
}


variable "location" {
  description = "The Azure Region in which to run vm"
  default = "eastus"
}

variable "machine_type" {
  description = "The Azure Machine Type for the  VM"
  default = "Standard_NC6s_v3"
}

variable "tf_vm_dns_label" {
  description = "An optional short public DNS name/label for the VM"
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk for the  VM (should be >= 128GB and >= 256 for large clusters)"
  default = "250"
}

variable "computer_name" {
    description =  "The private hostname for the  VM"
    default = "dsvmtf"
}

variable "tf_vm_username" {
  description = "The username for the initial vm Admin user and VM user"
  default = "administrator"
}

variable "tf_vm_password" {
  description = "The initial password for the vm Admin user"
}
variable "tf_vm_user_publickey" {
  description = "The public key for the initial Admin user and VM user"
  default =""
}
