az extension add --name virtual-wan

echo "# VNETGW: Get parameters from onprem2 vnet gateway"
vnetgwtunnelip1=$(az network vnet-gateway show -n vnet-gw-onprem2 -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]" --output tsv)
echo "VNET GW Tunnel address #1:" $vnetgwtunnelip1
vnetgwtunnelip2=$(az network vnet-gateway show -n vnet-gw-onprem2 -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[1].tunnelIpAddresses[0]" --output tsv)
echo "VNET GW Tunnel address #2:" $vnetgwtunnelip2
vnetgwbgpip1=$(az network vnet-gateway show -n vnet-gw-onprem2 -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].defaultBgpIpAddresses"  --output tsv)
echo "VNET GW BGP address:" $vnetgwbgpip1
vnetgwbgpip2=$(az network vnet-gateway show -n vnet-gw-onprem2 -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[1].defaultBgpIpAddresses"  --output tsv)
echo "VNET GW BGP address:" $vnetgwbgpip2
vnetgwasn=$(az network vnet-gateway show -n vnet-gw-onprem2 -g vwan-microhack-spoke-rg --query "bgpSettings.asn" --output tsv)
echo "VNET GW BGP ASN:" $vnetgwasn
sharedkey="m1cr0hack"

echo "# VWAN: Create remote site"
az network vpn-site create --name onprem2 -g vwan-microhack-hub-rg --ip-address $vnetgwtunnelip1 --virtual-wan microhack-vwan --location northeurope --device-model VNETGW --device-vendor Azure --asn $vnetgwasn --bgp-peering-address $vnetgwbgpip1 --link-speed 100 --with-link true
az network vpn-site link add --name onprem2-link2 -g vwan-microhack-hub-rg --ip-address $vnetgwtunnelip2 --site-name onprem2 --asn $vnetgwasn --bgp-peering-address $vnetgwbgpip2 --link-speed 100

echo "# VWAN: Create connection - remote site link to hub gw"
az network vpn-gateway connection create --gateway-name microhack-we-hub-vng --name onprem2-connection  -g vwan-microhack-hub-rg --remote-vpn-site onprem2 --shared-key $sharedkey --enable-bgp true --no-wait

echo "# VWAN: Get parameters from VWAN Hub GW"
hubgwtunneladdress0=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].tunnelIpAddresses[0]" --output tsv)
hubgwtunneladdress1=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance1'].tunnelIpAddresses[0]" --output tsv)
echo "Hub GW Tunnel address0:" $hubgwtunneladdress0
echo "Hub GW Tunnel address1:" $hubgwtunneladdress1
hubgwbgpaddress0=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].defaultBgpIpAddresses" --output tsv)
hubgwbgpaddress1=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance1'].defaultBgpIpAddresses" --output tsv)
echo "Hub GW BGP address0:" $hubgwbgpaddress0
echo "Hub GW BGP address1:" $hubgwbgpaddress1
hubgwasn=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.asn" --output tsv)
echo "Hub GW BGP ASN:" $hubgwasn

echo "# create local network gateways"
az network local-gateway create -g vwan-microhack-spoke-rg -n lng2-0 --gateway-ip-address $hubgwtunneladdress0 --location westeurope --asn $hubgwasn --bgp-peering-address $hubgwbgpaddress0
az network local-gateway create -g vwan-microhack-spoke-rg -n lng2-1 --gateway-ip-address $hubgwtunneladdress1 --location westeurope --asn $hubgwasn --bgp-peering-address $hubgwbgpaddress1

echo "# VNET GW: connect from vnet gw to local network gateways"
az network vpn-connection create -n to-we-hub2-0 --vnet-gateway1 vnet-gw-onprem2 -g vwan-microhack-spoke-rg --local-gateway2 lng2-0 -l westeurope --shared-key $sharedkey --enable-bgp
az network vpn-connection create -n to-we-hub2-1 --vnet-gateway1 vnet-gw-onprem2 -g vwan-microhack-spoke-rg --local-gateway2 lng2-1 -l westeurope --shared-key $sharedkey --enable-bgp
