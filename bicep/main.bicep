targetScope='subscription'

param location string

param vnetConfiguration object

var spokeRgFunctionName = 'rg-spoke-func-demo'
var spokeRgStorageName = 'rg-spoke-storage-demo'
var hubRgName = 'rg-hub-demo'

var spokeFunctionSuffix = uniqueString(spokeFunctionRg.id)
var strAccountNameDoc = 'strd${spokeFunctionSuffix}'
var strFunctionName = 'strf${spokeFunctionSuffix}'

resource spokeFunctionRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: spokeRgFunctionName
  location: location
}

resource spokeStorageRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: spokeRgStorageName
  location: location
}

resource hubRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: hubRgName
  location: location
}


module vnetSpokeFunction './modules/networking/vnet.spoke.function.bicep' = {
  scope: resourceGroup(spokeFunctionRg.name)
  name: 'vnetSpokeAse'
  params: {
    location: location
    vnetConfiguration: vnetConfiguration.spokeFunction
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

module storageFunction 'modules/storage/storage.bicep' = {
  scope: resourceGroup(spokeFunctionRg.name)
  name: 'storageFunction'
  params: {
    location: location
    name: strFunctionName
  }
}

module monitoring 'modules/monitoring/monitoring.bicep' = {
  scope: resourceGroup(spokeFunctionRg.name)
  name: 'monitoring'
  params: {
    location: location
    suffix: spokeFunctionSuffix
  }
}

// module function 'modules/function/function.bicep' = {
//   scope: resourceGroup(spokeFunctionRg.name)
//   name: 'function'
//   params: {
//     appInsightName: monitoring.outputs.appInsightName
//     location: location
//     strDocumentName: storageDocument.outputs.storageName
//     strFunctionName: storageFunction.outputs.storageName
//     suffix: spokeFunctionSuffix
//     strDocumentRgName: spokeStorageRg.name
//   }
// }
