$subscription="YOUR SUBSCRIPTION NAME OR ID"
$publisher="MARKETPLACE PUBLISHER"
$name="MARKETPLACE NAME"
$product="MARKETPLACE PRODUCT"

Connect-AzAccount

#Select subscription
Select-AzSubscription $subscription

#Verify if license terms were already accepted in subscription
Get-AzMarketplaceTerms -Publisher $publisher -Product $product -Name $name

#If accept = false then accept license terms
Get-AzMarketplaceTerms -Publisher $publisher -Product $product -Name $name | Set-AzMarketplaceTerms -Accept


