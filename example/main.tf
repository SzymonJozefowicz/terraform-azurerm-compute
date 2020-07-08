provider "azurerm" {
   features {}
}

data "azurerm_subscription" "current" {}
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

#Create a virtual network for all machines
resource "azurerm_resource_group" "net"{
    name = "${var.resource_group_prefix}-${var.prefix}-net-rg"
    location = var.location
    tags = var.tags
}


module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.net.name
  vnet_name           = "${var.prefix}-vnet"
  address_space       = "10.0.0.0/24"
  subnet_prefixes     = ["10.0.0.0/25", "10.0.0.128/25"]
  subnet_names        = ["servers", "computers"]
  tags = var.tags
}

// 1.  FortiAnalyzer Centralized Log Analytics
//     Subscription:   EUR INFRA Dev/Test
//     Resource Group: eur-infra-dev-net-forti-ana-rg
//     VM Name:        FortiAnalyzer

resource "azurerm_resource_group" "ana"{
    name = "${var.resource_group_prefix}-${var.prefix}-ana-rg"
    location = var.location
    tags = merge(var.tags,{"Application"="Fortinet Analyzer"})
}

module "fortinet-ana-nsg" {
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = azurerm_resource_group.ana.name
  security_group_name = "fortinet-ana-nsg"
  custom_rules = [
    {
      name                   = "SSH"
      priority               = "1000"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "22"
    },
    {
      name                   = "HTTP"
      priority               = "1010"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "80"
    },
    {
      name                   = "Port_514"
      priority               = "1020"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "514"
    },
    {
      name                   = "HTTPS"
      priority               = "1030"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "443"
    },
    {
      name                   = "Port_8000"
      priority               = "1040"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "8000"
    }

  ]
  
}

module "fortinet-ana"{
    source                      = "szymonjozefowicz/terraform-azurerm-compute"
    prefix                      = "fortinet-ana"
    resource_group_name         = azurerm_resource_group.ana.name
    location                    = azurerm_resource_group.ana.location
    subnet_id                   = module.network.vnet_subnets[0]
    network_security_group_id   = module.fortinet-ana-nsg.network_security_group_id
    public_ip_allocation_method = "Dynamic"
    vm_size                     = "Standard_F2"
    
    image_publisher             = "fortinet"
    image_offer                 = "fortinet-fortianalyzer"
    image_sku                   = "fortinet-fortianalyzer"
    image_version               = "6.2.5"
    
    plan_name                   = "fortinet-fortianalyzer"
    plan_publisher              = "fortinet"
    plan_product                = "fortinet-fortianalyzer"
    
    caching                     = "ReadWrite"
    create_option               = "fromImage"
    managed_disk_type           = "Standard_LRS"
    
    admin_username              = var.admin_username
    admin_password              = var.admin_password
    
}

