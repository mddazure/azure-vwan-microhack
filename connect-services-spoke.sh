servicesid=$(az network vnet show -g vwan-microhack-spoke-rg --name services-vnet --query "id" --output tsv)

# Note that the service-we connection should propogate to both West Europe hub's defaulRouteTable and RT-Shared-we,
# but the RT-Shared-we may not exist at the time this script is first run. If so, ignore errors.
defaultRtWeId=$(az network vhub route-table show --name defaultRouteTable --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --query id --output tsv)
sharedRtWeId=$(az network vhub route-table show --name RT-Shared-we --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --query id --output tsv 2>/dev/null)

az network vhub connection create --name services-we --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $servicesid --labels default --propagated $defaultRtWeId $sharedRtWeId
