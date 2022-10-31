targetScope='subscription'

param location string

param vnetConfiguration object

var hubRgName = 'rg-hub-ase-demo'
var spokeRgAseName = 'rg-spoke-ase-demo'

resource spokeAseRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: spokeRgAseName
  location: location
}

module vnetSpokeAse './modules/networking/vnet.spoke.ase.bicep' = {
  scope: resourceGroup(spokeAseRg.name)
  name: 'vnetSpokeAse'
  params: {
    location: location
    vnetConfiguration: vnetConfiguration.spokeAse
  }
}
