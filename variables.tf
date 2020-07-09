variable "prefix" {
  description = "The Prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which the resources in this example should exist"
}


variable "resource_group_name"{}
variable "subnet_id"{}
variable "vm_size"{
    default = "Standard_F2"
}

  
variable "image_publisher"{}
variable "image_offer"{}
variable "image_sku"{}
variable "image_version"{}
  
  
variable "plan_name"{
  default = ""
}
variable "plan_publisher"{
  default = ""
}
variable "plan_product"{
  default = ""
}

variable "caching"{}
variable "create_option"{}
variable "os_disk_managed_disk_type"{
  default = "Standard_LRS"
}

variable "admin_username"{}
variable "admin_password"{}

variable "network_security_group_id"{}
variable "public_ip_allocation_method"{}
variable "private_ip_address_allocation"{
  default = "Dynamic"
}
 
variable "number_of_instances"{
  default=1
}

variable "data_disk_count"{
  default=0
}

 variable "data_disk_size_gb"{
   default=0
 }

variable "data_disk_managed_disk_type"{
  default = "Standard_LRS"
}

