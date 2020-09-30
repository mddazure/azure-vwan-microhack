spoke1vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-1-vnet --query "id" --output tsv)
spoke2vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-2-vnet --query "id" --output tsv)
spoke3vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-3-vnet --query "id" --output tsv)
spoke4vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-4-vnet --query "id" --output tsv)
servicesvnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n services-vnet --query "id" --output tsv)

echo "# resetting connection spoke-1-we"
az network vhub connection create -n spoke-1-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $spoke1vnetid
echo "# resetting connection spoke-2-we"
az network vhub connection create -n spoke-2-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $spoke2vnetid
echo "# resetting connection services-we"
az network vhub connection create -n services-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $servicesvnetid
echo "# resetting connection spoke-3-useast"
az network vhub connection create -n spoke-3-useast -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --remote-vnet $spoke3vnetid
echo "# resetting connection spoke-4-useast"
az network vhub connection create -n spoke-4-useast -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --remote-vnet $spoke4vnetid

echo "# resetting branch connection to we"
sharedkey="m1cr0hack"
az network vpn-gateway connection create --gateway-name microhack-we-hub-vng --name onprem --remote-vpn-site onprem -g vwan-microhack-hub-rg --shared-key $sharedkey --enable-bgp true --no-wait

