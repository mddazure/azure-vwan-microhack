spoke3id=$(az network vnet show -g vwan-microhack-spoke-rg --name spoke-3-vnet --query "id" --output tsv)
spoke4id=$(az network vnet show -g vwan-microhack-spoke-rg --name spoke-4-vnet --query "id" --output tsv)
defaultRtUseastId=$(az network vhub route-table show --name defaultRouteTable --resource-group vwan-microhack-hub-rg --vhub-name microhack-useast-hub --query id --output tsv)
az network vhub connection create --name spoke-3-useast --resource-group vwan-microhack-hub-rg --vhub-name microhack-useast-hub --remote-vnet $spoke3id --labels default --propagated $defaultRtUseastId
az network vhub connection create --name spoke-4-useast --resource-group vwan-microhack-hub-rg --vhub-name microhack-useast-hub --remote-vnet $spoke4id --labels default --propagated $defaultRtUseastId
