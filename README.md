# terraform-azurerm-compute
Copy of Terraform Registry Azure Compute modules with support for markelplace images ( plan option )

Added plan setting for compute modules and variables to support it.

variable "use_plan"{
  type        = "string"
  description = "(Optional) Enable or disable plan section used by marketplace images"
  default     = "false"
}

variable "plan_name"{
  type        = "string"
  description = "(Optional) Provide plan name for marketplace vm image"
  default     = ""
}

variable "plan_publisher"{
  type        = "string"
  description = "(Optional) Provide plan publisher for marketplace vm image"
  default     = ""
}

variable "plan_product"{
  type        = "string"
  description = "(Optional) Provide plan products for marketplace vm image"
  default     = ""
}




Added markeplace terms approval powershell - required to deploy VM from marketplace.

Please adjust and run powershell on destination subscription before running Terraform or add it to "when create" section for resource group.



