# Create VM from Azure Markteplace

## Required license terms approval

Include Powershell script to access Marketplace Terms and Conditions.
This needs to be done once per subscription.

On desktop PC you will have to use elevated privileages.

```powershell
#Install Azure module in Powershell
Install-Module Az

#Autheticated to Azure
Connect-AzAccount

#Select subscription
Select-AzSubscription "YOUR SUBSRIPTION NAME"


#Set Variables
$publisher  = "publisher name"
$product    = "product"
$name       = "name"

#Verify if license terms were already accepted in subscription
Get-AzureRmMarketplaceTerms -Publisher $publisher -Product $product -Name $name

#If accept = false then accept license terms
Get-AzMarketplaceTerms -Publisher $publisher -Product $product -Name $name | Set-AzMarketplaceTerms -Accept
```

More details in link below

https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/virtual-machines/virtual_machine/managed-disks/from-marketplace-image


## Sample output for Fortinet Analyzer

```powershell
$publisher="fortinet"
$name="fortinet-fortianalyzer"
$product="fortinet-fortianalyzer"

Get-AzureRmMarketplaceTerms -Publisher $publisher -Product $product -Name $name


Publisher         : fortinet
Product           : fortinet-fortianalyzer
Plan              : fortinet-fortianalyzer
LicenseTextLink   : https://storelegalterms.blob.core.windows.net/legalterms/3E5ED...DFORTIANALYZER.txt
PrivacyPolicyLink : http://www.fortinet.com/doc/legal/EULA.pdf
Signature         : TAZR...PVZI
Accepted          : True
Signdate          : 2020-06-23 11:56:24
```



## Marketplace VM Module

module "vm"{
    source="./modules/vm"
    list of required varibles
    ....
    ....
    ....
}



