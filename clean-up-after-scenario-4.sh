spoke1vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-1-vnet --query "id" --output tsv)
spoke2vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-2-vnet --query "id" --output tsv)
spoke3vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-3-vnet --query "id" --output tsv)
spoke4vnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n spoke-4-vnet --query "id" --output tsv)
servicesvnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n services-vnet --query "id" --output tsv)
nvavnetid=$(az network vnet show -g vwan-microhack-spoke-rg -n nva-vnet --query "id" --output tsv)
wedefaultrtid=$(az network vhub route-table show --name defaultRouteTable --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --query id --output tsv)

echo "Removing associations and propagations from rt-shared-we"

wesharedrtid=$(az network vhub route-table show --name "RT-Shared-we" --resource-group "vwan-microhack-hub-rg" --vhub-name microhack-we-hub --query id --output tsv)
WERESTEP="https://management.azure.com${wesharedrtid}?api-version=2020-05-01"
az rest --method put --uri "$WERESTEP" --body @emptyrtbody.json
while [[ $(az rest --uri $WERESTEP | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done
spoke1connection=$(az network vhub connection show -n spoke-1-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --query "id" -o tsv)
spoke2connection=$(az network vhub connection show -n spoke-2-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --query "id" -o tsv)
servicesvnetconnection=$(az network vhub connection show -n services-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub --query "id" -o tsv)
WEVNETCONNECTIONSPOKE1="https://management.azure.com${spoke1connection}?api-version=2020-05-01"
WEVNETCONNECTIONSPOKE2="https://management.azure.com${spoke2connection}?api-version=2020-05-01"
WEVNETCONNECTIONSERVICES="https://management.azure.com${servicesvnetconnection}?api-version=2020-05-01"
sed "s#spokevnetid#$spoke1vnetid#g" emptyspokeconnection.json | tee emptyspokeconnection-spoke1.json
sed -i "s#wedefaultrtid#$wedefaultrtid#g" emptyspokeconnection-spoke1.json
sed "s#spokevnetid#$spoke2vnetid#g" emptyspokeconnection.json | tee emptyspokeconnection-spoke2.json
sed -i "s#wedefaultrtid#$wedefaultrtid#g" emptyspokeconnection-spoke2.json
sed "s#spokevnetid#$servicesvnetid#g" emptyspokeconnection.json | tee emptyspokeconnection-services.json
sed -i "s#wedefaultrtid#$wedefaultrtid#g" emptyspokeconnection-services.json
az rest --method put --uri $WEVNETCONNECTIONSPOKE1 --body @emptyspokeconnection-spoke1.json
while [[ $(az rest --uri $WEVNETCONNECTIONSPOKE1 | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done
az rest --method put --uri $WEVNETCONNECTIONSPOKE2 --body @emptyspokeconnection-spoke2.json
while [[ $(az rest --uri $WEVNETCONNECTIONSPOKE2 | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done
az rest --method put --uri $WEVNETCONNECTIONSERVICES --body @emptyspokeconnection-services.json
while [[ $(az rest --uri $WEVNETCONNECTIONSERVICES | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done

echo "Removing associations and propagations from rt-shared-useast"
useastdefaultrtid=$(az network vhub route-table show --name defaultRouteTable --resource-group vwan-microhack-hub-rg --vhub-name microhack-useast-hub --query id --output tsv)
useastsharedrtid=$(az network vhub route-table show --name "rt-shared-useast" --resource-group "vwan-microhack-hub-rg" --vhub-name microhack-useast-hub --query id --output tsv)
USEASTRESTEP="https://management.azure.com${useastsharedrtid}?api-version=2020-05-01"
az rest --method put --uri "$USEASTRESTEP" --body @emptyrtbody.json
while [[ $(az rest --uri $USEASTRESTEP | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done
spoke3connection=$(az network vhub connection show -n spoke-3-useast -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --query "id" -o tsv)
spoke4connection=$(az network vhub connection show -n spoke-4-useast -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub --query "id" -o tsv)
USEASTVNETCONNECTIONSPOKE3="https://management.azure.com${spoke3connection}?api-version=2020-05-01"
USEASTVNETCONNECTIONSPOKE4="https://management.azure.com${spoke4connection}?api-version=2020-05-01"
sed "s#spokevnetid#$spoke3vnetid#g" emptyspokeconnection.json | tee emptyspokeconnection-spoke3.json
sed -i "s#wedefaultrtid#$useastdefaultrtid#g" emptyspokeconnection-spoke3.json
sed "s#spokevnetid#$spoke4vnetid#g" emptyspokeconnection.json | tee emptyspokeconnection-spoke4.json
sed -i "s#wedefaultrtid#$useastdefaultrtid#g" emptyspokeconnection-spoke4.json
az rest --method put --uri $USEASTVNETCONNECTIONSPOKE3 --body @emptyspokeconnection-spoke3.json
while [[ $(az rest --uri $USEASTVNETCONNECTIONSPOKE3 | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done
az rest --method put --uri $USEASTVNETCONNECTIONSPOKE4 --body @emptyspokeconnection-spoke4.json
while [[ $(az rest --uri $USEASTVNETCONNECTIONSPOKE4 | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done


ONPREMCONNECTIONID=$(az network vpn-gateway list -g vwan-microhack-hub-rg --query [].connections[].id -o tsv)
ONPREMCONNECTIONRESTEP="https://management.azure.com${ONPREMCONNECTIONID}?api-version=2020-05-01"
ONPREMCONNECTIONVPNSITE=$(az network vpn-gateway list -g vwan-microhack-hub-rg --query [].connections[].remoteVpnSite.id -o tsv)
sed "s#wedefaultrtid#$wedefaultrtid#g" onpremconnection.json | tee onpremconnection-values.json
sed -i "s#ONPREMCONNECTIONVPNSITE#$ONPREMCONNECTIONVPNSITE#g" onpremconnection-values.json
az rest --method put --uri $ONPREMCONNECTIONRESTEP --body @onpremconnection-values.json
while [[ $(az rest --uri $ONPREMCONNECTIONRESTEP | jq .properties.provisioningState) != "\"Succeeded\"" ]]; do sleep 15; done

echo "Deleting rt-shared-useast"
az network vhub route-table delete --name rt-shared-useast -g vwan-microhack-hub-rg --vhub-name microhack-useast-hub
echo "Deleting rt-shared-we"
az network vhub route-table delete --name rt-shared-we -g vwan-microhack-hub-rg --vhub-name microhack-we-hub

echo "Disconnecting Branch"
az network vpn-gateway connection delete --gateway-name microhack-we-hub-vng --name onprem -g vwan-microhack-hub-rg
az network vpn-site delete --name onprem -g vwan-microhack-hub-rg

echo "Deleting VPN Gateway"
az network vpn-gateway delete --name microhack-we-hub-vng -g vwan-microhack-hub-rg

echo "Deleting resource groups"
az group delete --resource-group vwan-microhack-hub-rg --no-wait --yes
az group delete --resource-group vwan-microhack-spoke-rg --no-wait --yes