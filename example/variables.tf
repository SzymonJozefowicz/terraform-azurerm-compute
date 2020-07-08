variable "resource_group_prefix"{
    default = "eur-infra-sandbox"
}

variable "prefix"{
  default = "ns"
}

variable "location"{
    default = "eastus2"
}


variable "tags" {
  type        = map
  default = {
      Project = "Terraform Modules"
      Application = "VM From Terraform Module"
      Owner="Szymon Jozefowicz"
      Environment= "Sandbox"
      OwnerLogin="SZYMON"	
    }
  description = "Any tags which should be assigned to the resources in this example"
}

variable "admin_username"{
  default = "forti-admin"
}
variable "admin_password"{
}