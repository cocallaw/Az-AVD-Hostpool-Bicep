using 'main.bicep'

/*AVD Config*/
param hostPoolName = 'myAVDHostPool'
param sessionHostCount =  2
param maxSessionLimit =  5

/*VM Config*/
param vmNamePrefix =  'myAVDVM'
param adminUsername =  'superAdmin'
param adminPassword =  'NotaPassword!'

/*Network Config*/
param subnetName =  'mySubnet'
param vnetName =  'myVNet'
param vnetResourceGroup =  'myNetworkRG'
