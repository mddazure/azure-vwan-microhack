spoke1vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-1-vnet --query "id" --output tsv)
spoke2vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-2-vnet --query "id" --output tsv)
spoke3vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-3-vnet --query "id" --output tsv)
spoke4vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-4-vnet --query "id" --output tsv)
servicesvnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n services-vnet --query "id" --output tsv)
nvavnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n nva-vnet --query "id" --output tsv)
wedefaultrtid=$(az network vhub route-table show --name defaultRouteTable --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --query id --output tsv)

echo "# removing connection spoke-1-we"
az network vhub connection delete -n spoke-1-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --yes
echo "# removing connection spoke-2-we"
az network vhub connection delete -n spoke-2-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --yes
echo "# resetting connection services-we"
az network vhub connection create -n services-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $servicesvnetid --no-wait
echo "# resetting connection spoke-3-useast"
az network vhub connection create -n spoke-3-useast -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --remote-vnet $spoke3vnetid
echo "# resetting connection spoke-4-useast"
az network vhub connection create -n spoke-4-useast -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --remote-vnet $spoke4vnetid --no-wait
echo "connecting nva-vnet"
az network vhub connection create -n nva-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $nvavnetid --no-wait

echo "# resetting branch connection to we"
sharedkey="m1cr0hack"
az network vpn-gateway connection create --gateway-name microhack-we-hub-vng --name onprem --remote-vpn-site onprem -g vwan-microhack-hub-rg --shared-key $sharedkey --enable-bgp true --labels default --propagated $wedefaultrtid --no-wait

echo "#peering spoke-1-vnet to nva-vnet"
az network vnet peering create --name spoke1-to-nva --resource-group vwan-microhack-spoke-rg --vnet-name spoke-1-vnet --remote-vnet nva-vnet
az network vnet peering create --name nva-to-spoke1 --resource-group vwan-microhack-spoke-rg --vnet-name nva-vnet --remote-vnet spoke-1-vnet
echo "#peering spoke-2-vnet to nva-vnet"
az network vnet peering create --name spoke2-to-nva --resource-group vwan-microhack-spoke-rg --vnet-name spoke-2-vnet --remote-vnet nva-vnet
az network vnet peering create --name nva-to-spoke2 --resource-group vwan-microhack-spoke-rg --vnet-name nva-vnet --remote-vnet spoke-2-vnet

