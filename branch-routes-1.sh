hubgwbgpaddress=$(az network vpn-gateway show --name 1326fbdc69e84d66962a5224c49e6b23-eastus-gw  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].defaultBgpIpAddresses" --output tsv)
echo "Hub GW BGP address:" $hubgwbgpaddress

echo "# VNETGW: Verify BGP peer status"
az network vnet-gateway list-bgp-peer-status -n vnet-gw-onprem-1 -g vwan-microhack-spoke-rg

echo "# VNETGW: Display routes advertised from onprem gw to hub"
az network vnet-gateway list-advertised-routes -n vnet-gw-onprem-1 -g vwan-microhack-spoke-rg --peer $hubgwbgpaddress

echo "# VNETGW: Display routes learned by onprem gw from hub"
az network vnet-gateway list-learned-routes -n vnet-gw-onprem-1 -g vwan-microhack-spoke-rg
