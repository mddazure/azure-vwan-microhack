spoke1vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-1-vnet --query "id" --output tsv)
spoke2vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-2-vnet --query "id" --output tsv)
spoke3vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-3-vnet --query "id" --output tsv)
spoke4vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-4-vnet --query "id" --output tsv)
servicesvnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n services-vnet --query "id" --output tsv)
nvavnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n nva-vnet --query "id" --output tsv)

echo "# removing peerings to from spoke-vnet-1 to nva-vnet"
az network vnet peering delete --name spoke1-to-nva --resource-group vwan-microhack-spoke-rg --vnet-name spoke-1-vnet
az network vnet peering delete --name nva-to-spoke1 --resource-group vwan-microhack-spoke-rg --vnet-name nva-vnet 
echo "# removing peerings to from spoke-vnet-2 to nva-vnet"
az network vnet peering delete --name spoke2-to-nva --resource-group vwan-microhack-spoke-rg --vnet-name spoke-2-vnet
az network vnet peering delete --name nva-to-spoke2 --resource-group vwan-microhack-spoke-rg --vnet-name nva-vnet

echo "# disconnecting nva-vnet"
az network vhub connection delete -n nva-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --yes

echo "# connecting spoke-1-vnet"
az network vhub connection create --name spoke-1-we --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $spoke1vnetid --labels default
echo "# connecting spoke-2-vnet"
az network vhub connection create --name spoke-2-we --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $spoke2vnetid --labels default --no-wait

echo "#removing custom routes from microhack-we-hub"
az network vhub route-table route remove --index 1 -n defaultRouteTable -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --no-wait
az network vhub route-table route remove --index 1 -n defaultRouteTable -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --no-wait
echo "#removing custom routes from microhack-useast-hub"
az network vhub route-table route remove --index 1 -n defaultRouteTable -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --no-wait
az network vhub route-table route remove --index 1 -n defaultRouteTable -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --no-wait

echo "# detach UDR from vmSubnet in spoke-1-vnet"
az network vnet subnet update --resource-group vwan-microhack-spoke-rg --name vmSubnet --vnet-name spoke-1-vnet --route-table ""
echo "# detach UDR from vmSubnet in spoke-2-vnet"
az network vnet subnet update --resource-group vwan-microhack-spoke-rg --name vmSubnet --vnet-name spoke-2-vnet --route-table ""



