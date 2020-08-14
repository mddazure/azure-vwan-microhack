az extension add --name virtual-wan

echo "# VNETGW: Get parameters from onprem vnet gateway"
vnetgwtunnelip=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]" --output tsv)
echo "VNET GW Tunnel address:" $vnetgwtunnelip
vnetgwbgpip=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddress" --output tsv)
echo "VNET GW BGP address:" $vnetgwbgpip
vnetgwasn=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.asn" --output tsv)
echo "VNET GW BGP ASN:" $vnetgwasn
sharedkey="m1cr0hack"

echo "# VWAN: Create remote site"
az network vpn-site create --ip-address $vnetgwtunnelip --name onprem -g vwan-microhack-hub-rg --asn $vnetgwasn --bgp-peering-address $vnetgwbgpip --virtual-wan microhack-vwan --location northeurope --device-model VNETGW --device-vendor Azure --link-speed 100

echo "# VWAN: Create connection - remote site to hub gw"
az network vpn-gateway connection create --gateway-name microhack-we-hub-vng --name onprem --remote-vpn-site onprem -g vwan-microhack-hub-rg --shared-key $sharedkey --enable-bgp true --no-wait

echo "# VWAN: Get parameters from VWAN Hub GW"
hubgwtunneladdress=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].tunnelIpAddresses[0]" --output tsv)
echo "Hub GW Tunnel address:" $hubgwtunneladdress
hubgwbgpaddress=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].defaultBgpIpAddresses" --output tsv)
echo "Hub GW BGP address:" $hubgwbgpaddress
hubgwasn=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.asn" --output tsv)
echo "Hub GW BGP ASN:" $hubgwasn
hubgwkey=$(az network vpn-gateway connection show --gateway-name microhack-we-hub-vng --name onprem -g vwan-microhack-hub-rg --query "sharedKey" --output tsv)

echo "# create local network gateway"
az network local-gateway create -g vwan-microhack-spoke-rg -n lng --gateway-ip-address $hubgwtunneladdress --location westeurope --asn $hubgwasn --bgp-peering-address $hubgwbgpaddress

echo "# VNET GW: connect from vnet gw to local network gateway"
az network vpn-connection create -n to-we-hub --vnet-gateway1 vnet-gw-onprem -g vwan-microhack-spoke-rg --local-gateway2 lng -l northeurope --shared-key $sharedkey --enable-bgp

