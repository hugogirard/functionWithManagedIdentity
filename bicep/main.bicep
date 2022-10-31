targetScope='subscription'

param location string

param vnetConfiguration object

var spokeRgAseName = 'rg-spoke-ase-demo'
var spokeRgStorageName = 'rg-spoke-storage-demo'

var spokeAseSuffix = uniqueString(spokeAseRg.id)
var strAccountNameDoc = 'strd${spokeAseSuffix}'

resource spokeAseRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: spokeRgAseName
  location: location
}

resource spokeStorageRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: spokeRgStorageName
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

module storageDocument 'modules/storage/storage.bicep' = {
  scope: resourceGroup(spokeStorageRg.name)
  name: 'storageDocument'
  params: {
    location: location
    name: strAccountNameDoc
  }
}

module ase 'modules/ase/ase.bicep' = {
  scope: resourceGroup(spokeAseRg.name)
  name: 'ase'
  params: {
    location: location
    subnetId: vnetSpokeAse.outputs.vnetId
    suffix: spokeAseSuffix
  }
}
