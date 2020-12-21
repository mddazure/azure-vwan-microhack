## Scenario 1 / Task 1
az network nic show-effective-route-table -g vwan-microhack-spoke-rg -n spoke-1-nic --output table
# PoSh - Get-AzEffectiveRouteTable -ResourceGroupName vwan-microhack-spoke-rg -NetworkInterfaceName spoke-1-nic | ft

## Scenario 1 / Task 2
az network nic show-effective-route-table -g vwan-microhack-spoke-rg -n spoke-2-nic --output table
# PoSh - Get-AzEffectiveRouteTable -ResourceGroupName vwan-microhack-spoke-rg -NetworkInterfaceName spoke-2-nic | ft

## Scenario 2 / Task 1
