spoke1id=$(az network vnet show -g vwan-microhack-spoke-rg --name spoke-1-vnet --query "id" --output tsv)
spoke2id=$(az network vnet show -g vwan-microhack-spoke-rg --name spoke-2-vnet --query "id" --output tsv)
az network vhub connection create --name spoke-1-useast --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $spoke1id --labels default
az network vhub connection create --name spoke-2-useast --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --remote-vnet $spoke2id --labels default
