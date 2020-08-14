az extension add --name virtual-wan

# VNETGW: Get parameters from onprem gateway
vnetgwtunnelip=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]" --output tsv)
vnetgwbgpip=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddress" --output tsv)
vnetgwasn=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.asn" --output tsv)
sharedkey="m1cr0hack"

# VWAN: Create remote site
az network vpn-site create --ip-address $vnetgwtunnelip --name onprem -g vwan-microhack-hub-rg --asn $vnetgwasn --bgp-peering-address $vnetgwbgpip --virtual-wan microhack-vwan --location northeurope

# VWAN: Create connection - remote site to hub gw
az network vpn-gateway connection create --gateway-name microhack-we-hub-vng --name onprem --remote-vpn-site onprem -g vwan-microhack-hub-rg --shared-key $sharedkey --enable-bgp true

# VWAN: Get parameters from VWAN Hub GW
hubgwtunneladdress=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].tunnelIpAddresses[0]" --output tsv)
hubgwbgpaddress=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].defaultBgpIpAddresses" --output tsv)
hubgwasn=$(az network vpn-gateway show --name microhack-we-hub-vng  -g vwan-microhack-hub-rg --query "bgpSettings.asn" --output tsv)
hubgwkey=$(az network vpn-gateway connection show --gateway-name microhack-we-hub-vng --name onprem -g vwan-microhack-hub-rg --query "sharedKey" --output tsv)

# LNG
az network local-gateway create -g vwan-microhack-spoke-rg -n lng --gateway-ip-address $hubgwtunneladdress --location westeurope --asn $hubgwasn --bgp-peering-address $hubgwbgpaddress

# VNET GW: connect from vnet gw to local network gateway
az network vpn-connection create -n to-we-hub --vnet-gateway1 vnet-gw-onprem -g vwan-microhack-spoke-rg --local-gateway2 lng -l northeurope --shared-key $sharedkey --enable-bgp