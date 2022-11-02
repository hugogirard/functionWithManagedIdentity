param vnetConfiguration object
param location string

resource nsgAse 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-function'
  location: location
  properties: {
    securityRules: [
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetConfiguration.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetConfiguration.addressPrefixe
      ]
    }
    subnets: [
      {
        name: vnetConfiguration.subnets[0].name
        properties: {
          addressPrefix: vnetConfiguration.subnets[0].properties.addressPrefix
          networkSecurityGroup: {
            id: nsgAse.id
          }
        }
      }
    ]
  }
}

output vnetName string = vnet.name
output vnetId string = vnet.id
output subnets array = vnet.properties.subnets

