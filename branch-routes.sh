hubgwbgpaddress=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].defaultBgpIpAddresses" --output tsv)
echo "Hub GW BGP address:" $hubgwbgpaddress

echo "# VNETGW: Verify BGP peer status"
az network vnet-gateway list-bgp-peer-status -n vnet-gw-onprem -g vwan-microhack-spoke-rg --output table

echo "# VNETGW: Display routes advertised from onprem gw to hub"
az network vnet-gateway list-advertised-routes -n vnet-gw-onprem -g vwan-microhack-spoke-rg --peer $hubgwbgpaddress --output table

echo "# VNETGW: Display routes learned by onprem gw from hub"
az network vnet-gateway list-learned-routes -n vnet-gw-onprem -g vwan-microhack-spoke-rg --output table
