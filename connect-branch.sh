az extension add --name virtual-wan

echo "# VNETGW: Get parameters from onprem vnet gateway"
vnetgwtunnelip1=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]" --output tsv)
echo "VNET GW Tunnel address #1:" $vnetgwtunnelip1
vnetgwtunnelip2=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[1].tunnelIpAddresses[0]" --output tsv)
echo "VNET GW Tunnel address #2:" $vnetgwtunnelip2
vnetgwbgpip1=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].defaultBgpIpAddresses"  --output tsv)
echo "VNET GW BGP address:" $vnetgwbgpip1
vnetgwbgpip2=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[1].defaultBgpIpAddresses"  --output tsv)
echo "VNET GW BGP address:" $vnetgwbgpip2
vnetgwasn=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.asn" --output tsv)
echo "VNET GW BGP ASN:" $vnetgwasn
sharedkey="m1cr0hack"

echo "# VWAN: Create remote site"
az network vpn-site create --name onprem -g vwan-microhack-hub-rg --ip-address $vnetgwtunnelip1 --virtual-wan microhack-vwan --location uksouth --device-model VNETGW --device-vendor Azure --asn $vnetgwasn --bgp-peering-address $vnetgwbgpip1 --link-speed 100 --with-link true

echo "# VWAN: Create connection - remote site link to hub gw"
az network vpn-gateway connection create --gateway-name microhack-we-hub-vng --name onprem-connection  -g vwan-microhack-hub-rg --remote-vpn-site onprem --shared-key $sharedkey --enable-bgp true --no-wait

echo "# VWAN: Get parameters from VWAN Hub GW"
hubgwtunneladdress=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].tunnelIpAddresses[0]" --output tsv)
echo "Hub GW Tunnel address:" $hubgwtunneladdress
hubgwbgpaddress=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].defaultBgpIpAddresses" --output tsv)
echo "Hub GW BGP address:" $hubgwbgpaddress
hubgwasn=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.asn" --output tsv)
echo "Hub GW BGP ASN:" $hubgwasn

echo "# create local network gateway"
az network local-gateway create -g vwan-microhack-spoke-rg -n lng --gateway-ip-address $hubgwtunneladdress --location westeurope --asn $hubgwasn --bgp-peering-address $hubgwbgpaddress

echo "# VNET GW: connect from vnet gw to local network gateway"
az network vpn-connection create -n to-we-hub --vnet-gateway1 vnet-gw-onprem -g vwan-microhack-spoke-rg --local-gateway2 lng -l uksouth --shared-key $sharedkey --enable-bgp

